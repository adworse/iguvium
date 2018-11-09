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
LOGGER.formatter = proc do |severity, _, _, msg|
  "#{severity}: #{msg}\n"
end

# @author Dima Ermilov <wlaer@wlaer.com>
module Iguvium
  class << self
    # Reads PDF file and prepares it for recognition
    #
    # @param path [String] path to PDF file to be read
    # @option opts [Boolean] :images (false) consider pictures in PDF as possible table separators
    # @option opts [String] :gspath (nil) explicit path to the GhostScript executable. Use it in case of
    #   non-standard gs executable placement. If not specified, gem tries standard options
    #   like C:/Program Files/gs/gs*/bin/gswin??c.exe on Windows or just gs on Mac and Linux
    # @return [Array <Iguvium::Page>] filterable by page numbers or text. Filtering by {Iguvium::Page#text}
    #   does not require table parsing and is less expensive.
    #
    def read(path, **opts)
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

      PDF::Reader.new(path, opts).pages.map { |page| Page.new(page, path, opts) }
    end

    private

    def gs_nix?
      if `which gs`.empty?
        puts "There's no gs utility in your $PATH.
  Please install GhostScript with `brew install ghostscript` on Mac
  or download it here: https://www.ghostscript.com/download/gsdnld.html"
        exit
      end
      'gs'
    end

    def windows?
      RbConfig::CONFIG['host_os'].match?(/mswin|mingw|cygwin/)
    end
  end
end

# TODO: 4) Add options like maybe image thresholding
#
# TODO: 6) 0.9 - version capable of reading tables with open outer cells, like this:
# __|____|_______|_____|
# __|____|_______|_____|
# __|____|_______|_____|
#
# TODO: 7) 1.0 - in addition it should deal with merged cells (move result to the upper left cell).
