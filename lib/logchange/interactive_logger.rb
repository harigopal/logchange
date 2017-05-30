require_relative 'template'

module Logchange
  # Accept change information from the user via command line prompts.
  class InteractiveLogger
    def initialize
      @title = nil
      @template = {}
    end

    def execute
      input_title

      template = Logchange::Template.load

      template.each do |key, value|
        input(key, value)
      end

      Logchange::Logger.new(@title, template: @template).execute
    end

    private

    def input_title
      while @title.nil?
        print 'title: '
        @title = STDIN.gets.chomp

        if @title.length.zero?
          puts "Title cannot be blank.\n\n"
          @title = nil
        end
      end
    end

    def input(key, value)
      puts "#{key}: #{value}"
      user_input = STDIN.gets.chomp

      if user_input.length.positive?
        # Preserve booleans.
        if %w[true false].include?(user_input)
          user_input = (user_input == 'true')
        end

        @template[key] = user_input
      end

      puts "\n"
    end
  end
end
