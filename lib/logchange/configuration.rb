module Logchange
  # Store configuration for this gem.
  class Configuration
    attr_accessor :changelog_directory
    attr_accessor :root_path

    def initialize
      @changelog_directory = 'changelog'
      @root_path = Dir.pwd
    end

    def changelog_directory_path
      File.join(@root_path, @changelog_directory)
    end
  end
end
