module Logchange
  # Routes the user's command to appropriate handler.
  class Dispatch
    def execute
      ensure_changelog_directory_exists if %i[new release].include?(command)

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
          print_help
      end
    end

    private

    def ensure_changelog_directory_exists
      path = File.join(Logchange.configuration.changelog_directory_path, 'unreleased')
      return if File.directory?(path)
      abort("The changelog directory does not exist in this path. Run 'logchange init', or change to the correct path.")
    end

    def command
      return ARGV[0].to_sym if %w[init new release].include?(ARGV[0])
      :unknown
    end

    def print_help
      puts <<~HELP
        Usage: logchange COMMAND

        Available commands:
          init          - Initialize logchange at this location - creates
                          the changelog directory.
          new [MESSAGE] - Log a change. Skip the message to trigger
                          interative mode.
          release [TAG] - Releases changes in changelog/unreleased.
                          Optionally, tag the release with a string.
      HELP
    end
  end
end
