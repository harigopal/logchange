require 'fileutils'

module Logchange
  # Creates the changes directory if it doesn't exist, and logs the initialization.
  class Initialize
    def execute
      path = File.join(Logchange.configuration.changelog_directory_path, 'unreleased')

      if File.directory?(path)
        puts 'The changelog directory already exists. Cancelling.'
      else
        FileUtils.mkdir_p(path)
        Logchange::Logger.new('Added logchange to project.', public: false).execute
      end
    end
  end
end
