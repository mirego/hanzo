module Hanzo
  class Base

    attr_accessor :options

    def initialize(args)
      @args = args
      @options = OptionParser.new

      initialize_cli
    end

  end
end
