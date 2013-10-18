require 'optparse'
require 'yaml'
require 'highline/import'

require 'hanzo/base'
require 'hanzo/cli'
require 'hanzo/heroku'
require 'hanzo/version'

module Hanzo
  def self.run(command)
    print(command, :green)
    output = nil
    ::Bundler.with_clean_env { output = `#{command}` }
    output
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
    gsub /^#{scan(/^\s*/).min_by{|l|l.length}}/, ''
  end
end
