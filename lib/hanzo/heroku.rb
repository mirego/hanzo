module Hanzo
  module Heroku

    class << self

      def available_labs
        labs = []

        `bundle exec heroku labs`.each_line do |line|
          next unless line = /^\[\s\]\s+(?<name>\w+)\s+(?<description>.+)$/.match(line)

          labs << [line[:name], line[:description]]
        end

        labs
      end

    end

  end
end
