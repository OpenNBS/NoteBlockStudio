# frozen_string_literal: true

require "find"
require "open3"

def run_command(*arguments)
  output, status = Open3.capture2e(*arguments)
  raise "#{arguments.first} failed for #{arguments.last}:\n#{output}" unless status.success?

  output
end

if ENV.fetch("CODE_SIGNING_ALLOWED", "YES") == "NO"
  puts "Skipping embedded code signing because code signing is disabled."
  exit 0
end

identity = ENV["EXPANDED_CODE_SIGN_IDENTITY"].to_s
identity = ENV["CODE_SIGN_IDENTITY"].to_s if identity.empty?
raise "Xcode did not provide a code signing identity." if identity.empty?

resources = File.join(ENV.fetch("TARGET_BUILD_DIR"), ENV.fetch("UNLOCALIZED_RESOURCES_FOLDER_PATH"))
raise "App resources were not copied before embedded code signing: #{resources}" unless Dir.exist?(resources)

mach_o_magics = %w[feedface cefaedfe feedfacf cffaedfe cafebabe bebafeca cafebabf bfbafeca].freeze
embedded_code = []

Find.find(resources) do |path|
  next unless File.file?(path) && !File.symlink?(path)
  header = File.binread(path, 4)
  next unless header && mach_o_magics.include?(header.unpack1("H*"))

  description = run_command("/usr/bin/file", "-b", path)
  type = if description.match?(/Mach-O (?:32-bit|64-bit) executable/)
           :executable
         elsif description.match?(/Mach-O (?:32-bit|64-bit) (?:bundle|dynamically linked shared library)/)
           :library
         end
  embedded_code << [path, type] if type
end

# Sign inner code first. Xcode signs the containing .app after this build phase.
embedded_code.sort_by! { |path, _type| [-path.count(File::SEPARATOR), path] }
timestamp = identity != "-" && (ENV["ACTION"] == "install" || ENV.fetch("CODE_SIGN_IDENTITY", "").include?("Developer ID Application"))

embedded_code.each do |path, type|
  if type == :executable
    File.chmod(File.stat(path).mode | 0o111, path)
  end

  command = ["/usr/bin/codesign", "--force", "--sign", identity,
             "--preserve-metadata=identifier,entitlements"]
  command += ["--options", "runtime"] if type == :executable
  command << "--timestamp" if timestamp
  command << path
  run_command(*command)
  run_command("/usr/bin/codesign", "--verify", "--strict", path)
end

puts "Signed #{embedded_code.count { |_path, type| type == :executable }} embedded executables and " \
     "#{embedded_code.count { |_path, type| type == :library }} embedded libraries in Resources."
