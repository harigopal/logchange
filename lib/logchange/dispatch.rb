module Logchange
  # Routes the user's command to appropriate handler.
  class Dispatch
    def execute
      ensure_changelog_directory_exists unless command == :init

      case command
        when :init
          Logchange::Initialize.new.execute
        when :new
          if ARGV[1].nil?
            Logchange::InteractiveLogger.new.execute
          else
            Logchange::Logger.new(ARGV[1]).execute
          end
        when :release
          Logchange::Release.new(ARGV[1]).execute
        else
          raise "Unhandled command #{command}"
      end
    end

    private

    def ensure_changelog_directory_exists
      path = File.join(Logchange.configuration.changelog_directory_path, 'unreleased')
      return if File.directory?(path)
      raise "The changelog directory does not exist in this path. Run 'logchange init', or change to the correct path."
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
