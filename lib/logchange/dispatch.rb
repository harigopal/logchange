require 'fileutils'

module Logchange
  # Routes the user's command to appropriate handler.
  class Dispatch
    def execute
      ensure_changelog_directory_exists unless command == :init

      case command
        when :init
          Logchange::Initialize.new.execute
        when :new
          Logchange::Logger.new(ARGV[1]).execute
        else
          raise "Unhandled command #{command}"
      end
    end

    private

    def ensure_changelog_directory_exists
      return if File.directory?(Logchange.configuration.changelog_directory_path)
      raise "The 'changes' directory does not exist in this path. Create this directory, or change to the correct path."
    end

    def command
      return ARGV[0].to_sym if %w[init new release preview].include?(ARGV[0])
      print_help
    end

    def print_help
      # TODO: Write actual help response.
      raise 'Unknown command encountered.'
    end
  end
end