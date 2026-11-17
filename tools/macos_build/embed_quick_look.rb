# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "shellwords"

def run_command(*arguments)
  output, status = Open3.capture2e(*arguments)
  raise "#{arguments.first} failed:\n#{output}" unless status.success?

  output
end

if Shellwords.split(ENV.fetch("OTHER_CODE_SIGN_FLAGS", "")).include?("--deep")
  raise "Remove --deep from Other Code Signing Flags or rerun Prepare macOS Build.command. " \
        "Recursive signing replaces the preview's entitlements with the containing app's entitlements."
end

source = ENV.fetch("SCRIPT_INPUT_FILE_0")
contents = File.join(ENV.fetch("TARGET_BUILD_DIR"), ENV.fetch("CONTENTS_FOLDER_PATH"))
destination = File.join(contents, "PlugIns", "NBSQuickLook.appex")
helper_relative_path = "Contents/XPCServices/NBSSoundLibrary.xpc"
parent_helper = File.join(contents, "XPCServices", "NBSSoundLibrary.xpc")
raise "Missing prebuilt Quick Look extension: #{source}" unless File.file?(File.join(source, "Contents/MacOS/NBSQuickLook"))
raise "Missing Quick Look sound-library helper." unless File.file?(File.join(source, helper_relative_path, "Contents/MacOS/NBSSoundLibrary"))
raise "The source extension and built app must be separate." if File.expand_path(source) == File.expand_path(destination)

# Never edit or sign the repository's copy. Xcode owns this build-product directory.
FileUtils.mkdir_p(File.dirname(destination))
FileUtils.rm_r(destination) if File.exist?(destination)
FileUtils.cp_r(source, destination, preserve: true)

app_info = File.join(contents, "Info.plist")
app = JSON.parse(run_command("/usr/bin/plutil", "-convert", "json", "-o", "-", app_info))
preview_info = File.join(destination, "Contents/Info.plist")
preview = JSON.parse(run_command("/usr/bin/plutil", "-convert", "json", "-o", "-", preview_info))
nested_helper = File.join(destination, helper_relative_path)
helper_info = File.join(nested_helper, "Contents/Info.plist")
helper = JSON.parse(run_command("/usr/bin/plutil", "-convert", "json", "-o", "-", helper_info))
unless preview.fetch("CFBundleIdentifier").start_with?(app.fetch("CFBundleIdentifier") + ".")
  raise "The Quick Look extension's bundle ID must be a child of the containing app's bundle ID."
end
unless helper.fetch("CFBundleIdentifier") == app.fetch("CFBundleIdentifier") + ".preview.soundlibrary"
  raise "The sound-library helper's bundle ID must match the containing app's Quick Look service."
end
%w[CFBundleShortVersionString CFBundleVersion].each do |key|
  run_command("/usr/bin/plutil", "-replace", key, "-string", app.fetch(key).to_s, preview_info)
  run_command("/usr/bin/plutil", "-replace", key, "-string", app.fetch(key).to_s, helper_info)
end

if ENV.fetch("CODE_SIGNING_ALLOWED", "YES") == "NO"
  # The Info.plist changed, so an old signature must not masquerade as valid.
  run_command("/usr/bin/codesign", "--remove-signature", nested_helper)
  run_command("/usr/bin/codesign", "--remove-signature", destination)
  FileUtils.mkdir_p(File.dirname(parent_helper))
  FileUtils.rm_r(parent_helper) if File.exist?(parent_helper)
  FileUtils.cp_r(nested_helper, parent_helper, preserve: true)
  puts "Embedded NBS Quick Look preview and sound-library helpers (code signing disabled)."
  exit 0
end

identity = ENV["EXPANDED_CODE_SIGN_IDENTITY"].to_s
identity = ENV["CODE_SIGN_IDENTITY"].to_s if identity.empty?
raise "Xcode did not provide a code signing identity for the preview." if identity.empty?

signing_flags = ["/usr/bin/codesign", "--force", "--sign", identity, "--options", "runtime"]
if identity != "-" && (ENV["ACTION"] == "install" || ENV.fetch("CODE_SIGN_IDENTITY", "").include?("Developer ID Application"))
  signing_flags << "--timestamp"
end

# Each client launches its own instance of this identical service. Only the
# service accesses its own persistent bookmark; no shared App Group is needed.
run_command(*signing_flags, "--identifier", helper.fetch("CFBundleIdentifier"),
            "--entitlements", File.join(nested_helper, "Contents/Resources/LibraryService.entitlements"), nested_helper)
FileUtils.mkdir_p(File.dirname(parent_helper))
FileUtils.rm_r(parent_helper) if File.exist?(parent_helper)
FileUtils.cp_r(nested_helper, parent_helper, preserve: true)
run_command(*signing_flags, "--identifier", preview.fetch("CFBundleIdentifier"),
            "--entitlements", File.join(destination, "Contents/Resources/QuickLook.entitlements"), destination)
run_command("/usr/bin/codesign", "--verify", "--strict", parent_helper)
run_command("/usr/bin/codesign", "--verify", "--strict", nested_helper)
run_command("/usr/bin/codesign", "--verify", "--strict", destination)
puts "Embedded and signed NBS Quick Look preview and sound-library helpers."
