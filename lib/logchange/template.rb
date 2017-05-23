module Logchange
  class Template
    def self.load
      template_path = File.join(Logchange.configuration.changelog_directory_path, 'template.yaml')
      return {} unless File.exist?(template_path)
      YAML.load(File.read(template_path))
    end
  end
end
