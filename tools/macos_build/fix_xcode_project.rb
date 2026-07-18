# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "optparse"
require "pathname"
require "tempfile"
require "xcodeproj"

module NoteBlockStudio
  XCODEPROJ_DISCARDED_REFERENCE_WARNINGS = []

  class FixerError < StandardError; end

  class MacOSBuildFixer
    INFO_PLIST_OVERLAY_KEYS = %w[
      CFBundleDocumentTypes
      CFBundleURLTypes
      ITSAppUsesNonExemptEncryption
      UTExportedTypeDeclarations
    ].freeze

    ENTITLEMENT_OVERLAY_KEYS = %w[
      com.apple.security.cs.disable-library-validation
      com.apple.security.files.bookmarks.app-scope
      com.apple.security.files.user-selected.read-write
    ].freeze

    XCODE_MANAGED_ENTITLEMENTS = %w[
      application-identifier
      com.apple.application-identifier
      com.apple.developer.team-identifier
      com.apple.security.get-task-allow
    ].freeze

    DYLIBS = [
      ["extensions/gmmacostools/libGMmacOSTools.dylib", "libGMmacOSTools.dylib"],
      ["extensions/GMaudioTools/libGMaudioTools.dylib", "libGMaudioTools.dylib"],
      ["extensions/pygml/libpygml.dylib", "libPygml.dylib"],
      ["extensions/pygml/libPython3.8.dylib", "libPython3.8.dylib"]
    ].freeze

    ICON_ASSETS = ["Icon.xcassets", "NBS Icon macOS.icon"].freeze
    OPTIONAL_EXECUTABLES = %w[ffmpeg ffprobe].freeze
    APP_ICON_NAME = "NBS Icon macOS"
    DEFAULT_TEAM_ID = "2WJ25NL8J5"
    DEFAULT_PROFILE = "onbs"

    def initialize(argv)
      @repo_root = Pathname.new(__dir__).join("../..").expand_path
      @options = {
        open_xcode: true,
        output_root: nil
      }
      @explicit_project = parse_options(argv)
      @mac_options = read_game_maker_options
      @expected_bundle_id = @mac_options.fetch("option_mac_app_id")
      @product_name = @mac_options.fetch("option_mac_display_name")
    end

    def run
      project_path = discover_project
      puts "Using Xcode project:"
      puts "  #{project_path}"
      puts

      project = if @validated_project_path == project_path
                  @validated_project
                else
                  Xcodeproj::Project.open(project_path.to_s)
                end
      report_discarded_references
      target = application_target(project)
      paths = generated_paths(project, target)

      validate_source_files
      merge_info_plist(paths.fetch(:info_plist))
      merge_entitlements(paths.fetch(:entitlements))
      copy_icon_assets(paths.fetch(:source_dir))
      copy_dylibs(paths.fetch(:supporting_dir))
      make_optional_tools_executable(paths.fetch(:supporting_dir))
      update_project(project, target, paths)
      project.save
      verify_result(project_path, paths)

      puts
      puts "macOS Xcode project prepared successfully."
      puts "Next: choose Product > Archive in Xcode."

      open_xcode(project_path) if @options.fetch(:open_xcode)
    end

    private

    def parse_options(argv)
      parser = OptionParser.new do |options|
        options.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options] [project.xcodeproj]"
        options.separator ""
        options.separator "With no project argument, the fixer uses the GameMaker output path from options_mac.yy."
        options.separator "A .xcodeproj can also be dragged onto Prepare macOS Build.command."
        options.separator ""
        options.on("--no-open", "Prepare the project without opening Xcode") do
          @options[:open_xcode] = false
        end
        options.on("--output-root PATH", "Override the GameMaker output root (primarily for testing)") do |path|
          @options[:output_root] = Pathname.new(path).expand_path
        end
        options.on("-h", "--help", "Show this help") do
          puts options
          exit 0
        end
      end

      remaining = parser.parse(argv)
      raise FixerError, "Expected at most one .xcodeproj path." if remaining.length > 1

      remaining.first
    rescue OptionParser::ParseError => error
      raise FixerError, error.message
    end

    def read_game_maker_options
      path = @repo_root.join("options/mac/options_mac.yy")
      raise FixerError, "GameMaker macOS options were not found at #{path}." unless path.file?

      text = path.read
      %w[option_mac_app_id option_mac_display_name option_mac_output_dir].to_h do |key|
        encoded_value = text[/"#{Regexp.escape(key)}"\s*:\s*("(?:\\.|[^"])*")/, 1]
        raise FixerError, "Could not read #{key} from #{path}." unless encoded_value

        [key, JSON.parse(encoded_value)]
      end
    end

    def discover_project
      if @explicit_project
        path = normalize_project_path(Pathname.new(@explicit_project).expand_path)
        reject_from_pc(path)
        validate_project(path)
        return path
      end

      output_root = @options[:output_root] || configured_output_root
      expected_path = expected_project_path(output_root)
      if expected_path.directory?
        validate_project(expected_path)
        return expected_path
      end

      search_root = output_root.join("GM_MAC")
      raise FixerError, "GameMaker output directory does not exist: #{search_root}" unless search_root.directory?

      candidates = Dir.glob(search_root.join("**/*.xcodeproj").to_s)
        .map { |path| Pathname.new(path).expand_path }
        .select(&:directory?)
        .reject { |path| from_pc?(path) }
        .select { |path| valid_project?(path) }

      case candidates.length
      when 1
        candidates.first
      when 0
        raise FixerError, <<~MESSAGE.strip
          No generated Note Block Studio Xcode project was found under #{search_root}.
          Run Create Executable in GameMaker first, or drag the generated .xcodeproj onto Prepare macOS Build.command.
        MESSAGE
      else
        formatted = candidates.sort.map { |path| "  - #{path}" }.join("\n")
        raise FixerError, <<~MESSAGE.strip
          More than one matching Xcode project was found. The fixer will not guess:
          #{formatted}
          Drag the project you want onto Prepare macOS Build.command.
        MESSAGE
      end
    end

    def configured_output_root
      override = ENV["NBS_MAC_OUTPUT_DIR"]
      raw_path = override && !override.empty? ? override : @mac_options.fetch("option_mac_output_dir")
      Pathname.new(File.expand_path(raw_path))
    end

    def expected_project_path(output_root)
      yyp_files = Dir.glob(@repo_root.join("*.yyp").to_s)
      raise FixerError, "Expected one .yyp file in #{@repo_root}, found #{yyp_files.length}." unless yyp_files.length == 1

      project_slug = File.basename(yyp_files.first, ".yyp").gsub(/[^0-9A-Za-z_]+/, "_")
      output_root.join("GM_MAC", project_slug, project_slug, "#{project_slug}.xcodeproj")
    end

    def normalize_project_path(path)
      path = path.dirname if path.basename.to_s == "project.pbxproj"
      return path if path.extname == ".xcodeproj"

      projects = path.directory? ? path.children.select { |child| child.extname == ".xcodeproj" } : []
      return projects.first if projects.length == 1

      raise FixerError, "Not an Xcode project: #{path}"
    end

    def reject_from_pc(path)
      return unless from_pc?(path)

      raise FixerError, "Refusing to modify GameMaker's FromPC staging project: #{path}"
    end

    def from_pc?(path)
      path.each_filename.any? { |part| part.downcase.include?("frompc") }
    end

    def valid_project?(path)
      validate_project(path)
      true
    rescue FixerError, StandardError
      false
    end

    def validate_project(path)
      raise FixerError, "Xcode project does not exist: #{path}" unless path.directory?
      raise FixerError, "Missing project.pbxproj in #{path}." unless path.join("project.pbxproj").file?

      project = Xcodeproj::Project.open(path.to_s)
      target = application_target(project)
      info_path = generated_paths(project, target).fetch(:info_plist)
      bundle_id = read_plist(info_path).fetch("CFBundleIdentifier", nil)
      if bundle_id == @expected_bundle_id
        @validated_project_path = path
        @validated_project = project
        return
      end

      raise FixerError, "Expected bundle ID #{@expected_bundle_id}, found #{bundle_id.inspect} in #{path}."
    rescue KeyError => error
      raise FixerError, "Could not validate #{path}: #{error.message}"
    end

    def application_target(project)
      targets = project.targets.select { |target| target.product_type == "com.apple.product-type.application" }
      return targets.first if targets.length == 1

      expected_name = File.basename(Dir.glob(@repo_root.join("*.yyp").to_s).first.to_s, ".yyp").tr(" ", "_")
      matching = targets.select { |target| target.name == expected_name }
      return matching.first if matching.length == 1

      raise FixerError, "Expected exactly one macOS application target, found #{targets.length}."
    end

    def generated_paths(project, target)
      project_dir = Pathname.new(project.path).dirname.expand_path
      info_setting = first_build_setting(target, "INFOPLIST_FILE")
      raise FixerError, "The application target has no INFOPLIST_FILE setting." unless info_setting

      info_plist = resolve_project_path(info_setting, project_dir)
      entitlements_setting = first_build_setting(target, "CODE_SIGN_ENTITLEMENTS")
      entitlements = if entitlements_setting
                       resolve_project_path(entitlements_setting, project_dir)
                     else
                       info_plist.dirname.join("Minecraft_Note_Block_Studio.entitlements")
                     end

      supporting_dir = info_plist.dirname
      source_dir = supporting_dir.dirname
      [info_plist, entitlements, supporting_dir, source_dir].each do |path|
        ensure_inside_project(path, project_dir)
      end

      raise FixerError, "Generated Info.plist was not found: #{info_plist}" unless info_plist.file?
      raise FixerError, "Generated entitlements were not found: #{entitlements}" unless entitlements.file?
      raise FixerError, "Generated Supporting Files directory was not found: #{supporting_dir}" unless supporting_dir.directory?

      {
        project_dir: project_dir,
        info_plist: info_plist,
        entitlements: entitlements,
        supporting_dir: supporting_dir,
        source_dir: source_dir
      }
    end

    def first_build_setting(target, key)
      target.build_configurations.map do |configuration|
        value = configuration.build_settings[key]
        value unless value.respond_to?(:empty?) && value.empty?
      end.compact.first
    end

    def resolve_project_path(setting, project_dir)
      value = Array(setting).first.to_s
        .gsub("$(SRCROOT)", project_dir.to_s)
        .gsub("${SRCROOT}", project_dir.to_s)
      Pathname.new(value).absolute? ? Pathname.new(value).expand_path : project_dir.join(value).expand_path
    end

    def ensure_inside_project(path, project_dir)
      child = path.expand_path.to_s
      parent = project_dir.expand_path.to_s + File::SEPARATOR
      return if child.start_with?(parent)

      raise FixerError, "Generated path points outside the Xcode project: #{path}"
    end

    def validate_source_files
      required = [
        @repo_root.join("Minecraft_Note_Block_Studio-Info.plist"),
        @repo_root.join("Minecraft_Note_Block_Studio.entitlements")
      ]
      required.concat(ICON_ASSETS.map { |name| @repo_root.join(name) })
      required.concat(DYLIBS.map { |source, _destination| @repo_root.join(source) })

      missing = required.reject(&:exist?)
      return if missing.empty?

      raise FixerError, "Required fixer inputs are missing:\n#{missing.map { |path| "  - #{path}" }.join("\n")}"
    end

    def merge_info_plist(generated_path)
      generated = read_plist(generated_path)
      overlay = read_plist(@repo_root.join("Minecraft_Note_Block_Studio-Info.plist"))

      INFO_PLIST_OVERLAY_KEYS.each do |key|
        raise FixerError, "Custom Info.plist is missing #{key}." unless overlay.key?(key)

        generated[key] = overlay.fetch(key)
      end

      generated.delete("CFBundleIconFile")
      generated.delete("CFBundleIconName")
      write_plist(generated_path, generated)
    end

    def merge_entitlements(generated_path)
      generated = read_plist(generated_path)
      overlay = read_plist(@repo_root.join("Minecraft_Note_Block_Studio.entitlements"))

      ENTITLEMENT_OVERLAY_KEYS.each do |key|
        raise FixerError, "Custom entitlements are missing #{key}." unless overlay.key?(key)

        generated[key] = overlay.fetch(key)
      end

      XCODE_MANAGED_ENTITLEMENTS.each { |key| generated.delete(key) }
      write_plist(generated_path, generated)
    end

    def read_plist(path)
      output, status = Open3.capture2e("/usr/bin/plutil", "-convert", "json", "-o", "-", path.to_s)
      raise FixerError, "Could not read plist #{path}:\n#{output}" unless status.success?

      JSON.parse(output)
    rescue JSON::ParserError => error
      raise FixerError, "Could not parse plist #{path}: #{error.message}"
    end

    def write_plist(path, contents)
      Tempfile.create(["nbs-plist", ".json"], path.dirname.to_s) do |json_file|
        json_file.write(JSON.pretty_generate(contents))
        json_file.flush

        xml, status = Open3.capture2e("/usr/bin/plutil", "-convert", "xml1", "-o", "-", json_file.path)
        raise FixerError, "Could not serialize plist #{path}:\n#{xml}" unless status.success?

        mode = path.file? ? path.stat.mode : 0o644
        Tempfile.create([path.basename.to_s, ".tmp"], path.dirname.to_s) do |destination|
          destination.binmode
          destination.write(xml)
          destination.flush
          destination.fsync
          File.chmod(mode, destination.path)
          File.rename(destination.path, path.to_s)
        end
      end
    end

    def copy_icon_assets(destination_dir)
      ICON_ASSETS.each do |name|
        source = @repo_root.join(name)
        destination = destination_dir.join(name)
        remove_exact_destination(destination, destination_dir)
        FileUtils.cp_r(source.to_s, destination.to_s, preserve: true)
      end
    end

    def copy_dylibs(supporting_dir)
      DYLIBS.each do |source_name, destination_name|
        source = @repo_root.join(source_name)
        destination = supporting_dir.join(destination_name)
        FileUtils.cp(source.to_s, destination.to_s, preserve: true)
      end
    end

    def make_optional_tools_executable(supporting_dir)
      found = OPTIONAL_EXECUTABLES.map do |name|
        path = supporting_dir.join(name)
        next unless path.file?

        File.chmod((path.stat.mode & 0o7777) | 0o111, path.to_s)
        name
      end.compact
      puts "Restored executable permissions for: #{found.join(", ")}" unless found.empty?
    end

    def remove_exact_destination(destination, allowed_parent)
      expanded = destination.expand_path
      expected_parent = allowed_parent.expand_path.to_s + File::SEPARATOR
      unless expanded.to_s.start_with?(expected_parent) && ICON_ASSETS.include?(expanded.basename.to_s)
        raise FixerError, "Refusing to replace unexpected path: #{destination}"
      end

      FileUtils.rm_r(expanded.to_s) if expanded.exist?
    end

    def update_project(project, target, paths)
      resources_group = resources_group(project, paths.fetch(:info_plist))
      ICON_ASSETS.each do |name|
        reference = find_or_create_reference(project, resources_group, paths.fetch(:source_dir).join(name))
        reference.last_known_file_type = "folder.iconcomposer.icon" if name.end_with?(".icon")
        add_to_phase(target.resources_build_phase, reference)
      end

      framework_group = project.frameworks_group
      embed_phase = framework_embed_phase(target)
      DYLIBS.each do |_source, destination_name|
        destination = paths.fetch(:supporting_dir).join(destination_name)
        reference = find_or_create_reference(project, framework_group, destination)
        add_to_phase(target.frameworks_build_phase, reference)
        build_file = add_to_phase(embed_phase, reference)
        build_file.settings ||= {}
        attributes = Array(build_file.settings["ATTRIBUTES"])
        build_file.settings["ATTRIBUTES"] = attributes | ["CodeSignOnCopy"]
      end

      team_id = signing_team_id(target)
      signing_style = ENV.fetch("NBS_MAC_SIGNING_STYLE", "Manual").capitalize
      unless %w[Automatic Manual].include?(signing_style)
        raise FixerError, "NBS_MAC_SIGNING_STYLE must be Automatic or Manual."
      end

      profile = ENV.fetch("NBS_MAC_PROVISIONING_PROFILE", DEFAULT_PROFILE)
      if signing_style == "Manual" && profile.empty?
        raise FixerError, "Manual signing requires NBS_MAC_PROVISIONING_PROFILE."
      end

      target.build_configurations.each do |configuration|
        settings = configuration.build_settings
        settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = APP_ICON_NAME
        settings["CODE_SIGN_STYLE"] = signing_style
        settings["DEVELOPMENT_TEAM"] = ""
        settings["DEVELOPMENT_TEAM[sdk=macosx*]"] = team_id
        settings["ENABLE_HARDENED_RUNTIME"] = "YES"
        settings["PRODUCT_NAME"] = @product_name
        settings["PROVISIONING_PROFILE"] = ""
        settings["PROVISIONING_PROFILE_SPECIFIER"] = ""
        if signing_style == "Manual"
          settings["PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]"] = profile
        else
          settings.delete("PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]")
        end
      end

      target.product_reference.path = "#{@product_name}.app" if target.product_reference

      target_attributes = project.root_object.attributes["TargetAttributes"] ||= {}
      attributes = target_attributes[target.uuid] ||= {}
      attributes["DevelopmentTeam"] = team_id
      attributes["ProvisioningStyle"] = signing_style
    end

    def resources_group(project, info_plist)
      reference = project.files.find do |file|
        file.path && file.real_path.expand_path == info_plist.expand_path
      rescue StandardError
        false
      end
      return reference.parent if reference&.parent.is_a?(Xcodeproj::Project::Object::PBXGroup)

      groups = project.groups.select { |group| group.display_name == "Resources" }
      return groups.first if groups.length == 1

      raise FixerError, "Could not identify the Xcode Resources group."
    end

    def find_or_create_reference(project, group, path)
      expanded_path = path.expand_path
      existing = project.files.find do |file|
        file.path && file.real_path.expand_path == expanded_path
      rescue StandardError
        false
      end
      return existing if existing

      relative_path = expanded_path.relative_path_from(group.real_path.expand_path)
      group.new_file(relative_path.to_s)
    end

    def add_to_phase(phase, reference)
      existing = phase.files.find { |build_file| build_file.file_ref == reference }
      existing || phase.add_file_reference(reference, true)
    end

    def framework_embed_phase(target)
      phase = target.copy_files_build_phases.find { |candidate| candidate.dst_subfolder_spec.to_s == "10" }
      return phase if phase

      target.new_copy_files_build_phase("Embed Frameworks").tap do |new_phase|
        new_phase.dst_subfolder_spec = "10"
      end
    end

    def signing_team_id(target)
      override = ENV["NBS_MAC_TEAM_ID"]
      return override unless override.nil? || override.empty?

      candidates = target.build_configurations.flat_map do |configuration|
        settings = configuration.build_settings
        [settings["DEVELOPMENT_TEAM[sdk=macosx*]"], settings["DEVELOPMENT_TEAM"]]
      end
      candidates.compact.find { |value| !value.to_s.empty? }.to_s.then do |value|
        value.empty? ? DEFAULT_TEAM_ID : value
      end
    end

    def verify_result(project_path, paths)
      [paths.fetch(:info_plist), paths.fetch(:entitlements)].each do |plist|
        output, status = Open3.capture2e("/usr/bin/plutil", "-lint", plist.to_s)
        raise FixerError, "Plist validation failed for #{plist}:\n#{output}" unless status.success?
      end

      project = Xcodeproj::Project.open(project_path.to_s)
      target = application_target(project)
      expected_files = ICON_ASSETS + DYLIBS.map(&:last)
      missing = expected_files.reject do |name|
        project.files.any? { |file| file.path && File.basename(file.path.to_s) == name }
      end
      raise FixerError, "Xcode project verification failed; missing references: #{missing.join(", ")}" unless missing.empty?

      target.build_configurations.each do |configuration|
        settings = configuration.build_settings
        raise FixerError, "Product name was not set in #{configuration.name}." unless settings["PRODUCT_NAME"] == @product_name
        unless settings["ENABLE_HARDENED_RUNTIME"] == "YES"
          raise FixerError, "Hardened Runtime was not enabled in #{configuration.name}."
        end
      end
    end

    def open_xcode(project_path)
      return if system("/usr/bin/open", project_path.to_s)

      warn "The project was fixed, but Xcode could not be opened automatically."
    end

    def report_discarded_references
      count = XCODEPROJ_DISCARDED_REFERENCE_WARNINGS.length
      return if count.zero?

      puts "Cleaned #{count} stale file #{count == 1 ? "reference" : "references"} left by GameMaker."
      puts
      XCODEPROJ_DISCARDED_REFERENCE_WARNINGS.clear
    end
  end
end

module Xcodeproj
  module UserInterface
    class << self
      alias nbs_original_warn warn

      def warn(message)
        if message.include?("attempted to initialize an object with an unknown UUID") &&
           message.include?("the unknown UUID is being discarded")
          NoteBlockStudio::XCODEPROJ_DISCARDED_REFERENCE_WARNINGS << message
        else
          nbs_original_warn(message)
        end
      end
    end
  end
end

begin
  NoteBlockStudio::MacOSBuildFixer.new(ARGV).run
rescue NoteBlockStudio::FixerError => error
  warn "Error: #{error.message}"
  exit 1
rescue StandardError => error
  warn "Unexpected error: #{error.class}: #{error.message}"
  warn error.backtrace.join("\n") if ENV["NBS_MAC_FIXER_DEBUG"] == "1"
  exit 1
end
