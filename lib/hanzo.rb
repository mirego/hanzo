require 'optparse'
require 'yaml'
require 'highline/import'

require 'hanzo/base'
require 'hanzo/cli'
require 'hanzo/heroku'
require 'hanzo/version'

module Hanzo
  def self.run(command, fetch_output = false)
    print(command, :green)
    output = true

    _run do
      if fetch_output
        output = `#{command}`
      else
        system(command)
      end
    end

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
    text = text.join("\n       ") if text.is_a?(Array)
    HighLine.say HighLine.color("       #{text}", *colors)
  end

  def self.title(text)
    HighLine.say HighLine.color("-----> #{text}", :blue)
  end

  def self.agree(question)
    HighLine.agree "       #{question} "
  end

  def self.ask(question, &blk)
    HighLine.ask "-----> #{question} ", &blk
  end
end

class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by { |l| l.length }}/, '')
  end
end
