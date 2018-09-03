# Dependencies
require 'optparse'
require 'yaml'
require 'highline/import'

# Base
require 'hanzo/base'
require 'hanzo/cli'
require 'hanzo/version'

# Providers
require 'hanzo/dokku'
require 'hanzo/heroku'

# Modules
require 'hanzo/modules/config'
require 'hanzo/modules/console'
require 'hanzo/modules/deploy'
require 'hanzo/modules/diff'
require 'hanzo/modules/install'

# Fetchers
require 'hanzo/fetchers/environment'

module Hanzo
  # Constants
  OUTPUT_PREFIX = '-----> '.freeze

  def self.run(command, fetch_output = false)
    print(command, :green)
    output = true

    _run { output = fetch_output ? `#{command}` : system(command) }

    output
  end

  def self._run(&blk)
    if defined?(Bundler)
      ::Bundler.with_clean_env(&blk)
    else
      blk.call
    end
  end

  def self.print(text = '', *colors)
    colors = colors.map { |c| HighLine.const_get(c.to_s.upcase) }
    text = text.join("\n#{' ' * OUTPUT_PREFIX.length}") if text.is_a?(Array)
    HighLine.say(HighLine.color("#{' ' * OUTPUT_PREFIX.length}#{text}", *colors))
  end

  def self.unindent_print(text = '', *colors)
    colors = colors.map { |c| HighLine.const_get(c.to_s.upcase) }
    HighLine.say(HighLine.color(text, *colors))
  end

  def self.title(text)
    HighLine.say(HighLine.color("#{OUTPUT_PREFIX}#{text}", :blue))
  end

  def self.agree(question)
    HighLine.agree("#{' ' * OUTPUT_PREFIX.length}#{question} ")
  end

  def self.ask(question, &blk)
    HighLine.ask("#{OUTPUT_PREFIX}#{question} ", &blk)
  end

  def self.config
    return YAML.load_file('.hanzo.yml') if File.exist?('.hanzo.yml')

    Hanzo.print('Cannot locate .hanzo.yml')
    Hanzo.print('For more information, please read https://github.com/mirego/hanzo')

    exit
  end
end

class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by(&:length)}/, '')
  end
end
