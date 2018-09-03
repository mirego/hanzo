module Hanzo
  class Base
    # Accessors
    attr_accessor :options

    def initialize(args)
      @args = args
      @options = OptionParser.new

      initialize_help
      initialize_variables
      initialize_options
      puts(@options) if initialize_cli == false
    end

    def extract_argument(index)
      @args[index]
    end

  private

    def initialize_options
      # Should be implemented by children if necessary
    end
  end
end
