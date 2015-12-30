require 'hanzo/modules/installers/remotes'
require 'hanzo/modules/installers/labs'

module Hanzo
  class Install < Base
    # Mixins
    include Hanzo::Installers::Remotes
    include Hanzo::Installers::Labs

  protected

    def initialize_variables
      @type = extract_argument(1)
    end

    def initialize_cli
      initialize_help && return if @type.nil?

      method = "install_#{@type}"

      if self.respond_to?(method)
        send(method)
      else
        initialize_help
      end
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo install TYPE

        Available install type:
          remotes - Add git remotes to current repository
      BANNER
    end
  end
end
