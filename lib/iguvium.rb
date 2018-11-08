# frozen_string_literal: true

require 'convolver-light'
require 'csv'
require 'fileutils'
require 'logger'
require 'matrix'
require 'oily_png'
require 'pdf-reader'
require 'rbconfig'

require_relative 'iguvium/labeler'
require_relative 'iguvium/cv'
require_relative 'iguvium/image'
require_relative 'iguvium/page'
require_relative 'iguvium/table'
require_relative 'iguvium/version'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::ERROR
LOGGER.formatter = proc do |severity, datetime, progname, msg|
  "#{severity}: #{msg}\n"
end

module Iguvium
  def self.read(path, **opts)
    if windows?
      opts[:gspath] ||= Dir.glob('C:/Program Files/gs/gs*/bin/gswin??c.exe').first
      if opts[:gspath].empty?
        puts "There's no gs utility in your $PATH.
Please install GhostScript: https://www.ghostscript.com/download/gsdnld.html"
        exit
      end
    else
      opts[:gspath] ||= gs_nix?
    end

    PDF::Reader.new(path, opts)
               .pages
               .map { |page| Page.new(page, path, opts) }
  end

  def self.gs_nix?
    if `which gs`.empty?
      puts "There's no gs utility in your $PATH.
Please install GhostScript with `brew install ghostscript` on Mac
or download it here: https://www.ghostscript.com/download/gsdnld.html"
      exit
    end
    'gs'
  end

  def self.windows?
    RbConfig::CONFIG['host_os'].match?(/mswin|mingw|cygwin/)
  end
end

# The gem is annoyingly slow. I've succeeded to speed it up at least a couple of times, but we need to go deeper.
#
# TODO: 4) Add options like maybe image thresholding
#
# 5) This will make it version 0.8. Some options, faster than now but still basic
#
# TODO: 6) 0.9 - version capable of reading tables with open outer cells, like this:
# __|____|_______|_____|
# __|____|_______|_____|
# __|____|_______|_____|
#
# TODO: 7) 1.0 - in addition it should deal with merged cells (placing result to the upper left cell on the grid).
