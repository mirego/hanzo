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
    `#{command}`
  end

  def self.print(text, *colors)
    colors = colors.map { |c| HighLine.const_get(c.to_s.upcase) }
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
