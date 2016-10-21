module FixturesHelpers
  def file_read(verb, name)
    file_name = build_file_name(verb, name)
    File.read(file_name)
  end

  def build_file_name(verb, name)
    name = [verb, name.gsub("/", "_")].join("_")
    "./spec/fixtures/#{name}.json"
  end
end
