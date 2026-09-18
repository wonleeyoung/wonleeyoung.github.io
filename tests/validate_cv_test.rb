require "tmpdir"
require "fileutils"
require "open3"
require "yaml"

root = File.expand_path("..", __dir__)
script = File.join(root, "scripts/validate_cv.rb")
abort "FAIL: YAML validator is not implemented" unless File.file?(script)
original = YAML.safe_load_file(File.join(root, "_data/cv.yml"))
cases = {
  "existing CV" => [true, nil, ->(d) {}],
  "missing name" => [false, "profile.name", ->(d) { d["profile"].delete("name") }],
  "empty authors" => [false, "publications[1].authors", ->(d) { d["publications"][0]["authors"] = [] }],
  "authors must be an array" => [false, "authors", ->(d) { d["publications"][0]["authors"] = "A, B" }],
  "wrong key" => [false, "titel", ->(d) { d["publications"][0]["titel"] = "typo" }],
  "unsafe URL" => [false, "url", ->(d) { d["profile"]["links"][0]["url"] = "javascript:alert(1)" }],
  "missing optional photo" => [true, "profile.photo", ->(d) { d["profile"]["photo"] = "/missing.jpg" }],
  "empty optional fields" => [true, nil, ->(d) { d["profile"]["social_links"] = [{"label"=>"Scholar", "url"=>""}]; d["extra_sections"] = [] }],
  "new section requires body" => [false, "body", ->(d) { d["extra_sections"] = [{"title"=>"Projects"}] }]
}
Dir.mktmpdir("cv-validation-") do |dir|
  FileUtils.cp(File.join(root, "cv.pdf"), File.join(dir, "cv.pdf"))
  FileUtils.mkdir_p(File.join(dir, "_data"))
  file = File.join(dir, "_data/cv.yml")
  cases.each do |name, (expected, message, change)|
    data = Marshal.load(Marshal.dump(original))
    change.call(data)
    File.write(file, YAML.dump(data))
    output, status = Open3.capture2e(RbConfig.ruby, script, file)
    abort "FAIL #{name}: #{output}" unless status.success? == expected && (!message || output.include?(message))
    puts "PASS #{name}"
  end
  ["profile: [\n", "profile:\n  name: First\n  name: Second\n"].each do |invalid|
    File.write(file, invalid)
    output, status = Open3.capture2e(RbConfig.ruby, script, file)
    abort "FAIL YAML line diagnostics: #{output}" if status.success? || !output.match?(/cv.yml:\d+/)
  end
  puts "PASS syntax/duplicate-key line diagnostics"
end
