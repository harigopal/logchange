require 'yaml'
require 'time'

module Logchange
  # Logs a new change.
  class Logger
    def initialize(title)
      @title = title
    end

    def execute
      file_path = File.join(unreleased_path, filename)
      File.write(file_path, log_contents)
      puts "Created #{file_path}"
    end

    private

    def log_contents
      YAML.dump({
        'timestamp' => Time.now.utc.iso8601,
        'title' => @title
      }.merge(template))
    end

    def template
      template_path = File.join(Logchange.configuration.changelog_directory_path, 'template.yaml')
      return {} unless File.exists?(template_path)
      YAML.load(File.read(template_path))
    end

    def filename
      "#{datetime}-#{simplified_title}.yaml"
    end

    def simplified_title
      spaces_dashed = @title.tr(' ', '-')
      specials_removed = spaces_dashed.gsub(/[^\-0-9A-Za-z]/, '')[0..60]
      specials_removed.downcase
    end

    def unreleased_path
      File.join(Logchange.configuration.changelog_directory_path, 'unreleased')
    end

    def datetime
      "#{Time.now.utc.year}#{Time.now.utc.month.to_s.rjust(2, '0')}#{Time.now.utc.day.to_s.rjust(2, '0')}"
    end
  end
end
