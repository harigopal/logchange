require 'yaml'
require 'fileutils'

module Logchange
  # Releases new changes to a markdown log.
  class Release
    def initialize(tag)
      @tag = tag
    end

    def execute
      return if no_unreleased_changes?

      release_list = { 'timestamp' => Time.now.utc.iso8601 }
      release_list['tag'] = @tag unless @tag.nil?

      release_list['changes'] = unreleased_changelogs.map do |changelog_path|
        YAML.safe_load(File.read(changelog_path))
      end

      # Sort the list of changes by timestamp, in reverse.
      release_list['changes'] = release_list['changes'].sort_by do |changelog|
        Time.parse(changelog['timestamp'])
      end.reverse

      update_release_file(release_list)

      # Delete changelogs from unreleased directory.
      unreleased_changelogs.each { |changelog_path| FileUtils.rm(changelog_path) }
    end

    private

    def update_release_file(release)
      existing_release = if File.exist?(release_path)
        YAML.safe_load(File.read(release_path))
      else
        { 'changelog' => [] }
      end

      # Add latest release to the top of existing release's changelog.
      existing_release['changelog'] = [release] + existing_release['changelog']

      # Now write updated release back.
      File.write(release_path, YAML.dump(existing_release))

      puts "Released changes to #{release_path}."
    end

    def release_path
      filename = "#{Time.now.utc.year}.yaml"
      File.join(Logchange.configuration.changelog_directory_path, filename)
    end

    def no_unreleased_changes?
      return false if unreleased_changelogs.any?
      puts 'There are no unreleased changes.'
      true
    end

    def unreleased_changelogs
      @unreleased_changelogs ||= Dir[File.join(Logchange.configuration.changelog_directory_path, 'unreleased', '*.yaml')]
    end
  end
end
