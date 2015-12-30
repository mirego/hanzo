module Hanzo
  class Base
    # Accessors
    attr_accessor :options

    def initialize(args)
      @args = args
      @options = OptionParser.new

      initialize_variables
      initialize_cli
    end

    def extract_argument(index)
      (@args[index] =~ /-/) ? nil : @args[index]
    end
  end
end
