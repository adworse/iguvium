# frozen_string_literal: true

require 'convolver-light'
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

# PDF tables extractor.
# @example Get all the tables in 2D text array format
#   pages = Iguvium.read('filename.pdf') #=> [Array<Iguvium::Page>]
#   tables = pages.flat_map { |page| page.extract_tables! } #=> [Array<Iguvium::Table>]
#   tables.map(&:to_a)
# @example Get first table from the page 8
#   pages = Iguvium.read('filename.pdf')
#   tables = pages[7].extract_tables!
#   tables.first.to_a
# For more details please look {Iguvium.read} and {Iguvium::Page#extract_tables!}
# @author Dima Ermilov <wlaer@wlaer.com>
#
module Iguvium
  class << self
    # It's main method. Usually this is where you start.
    #
    # It returns an array of {Iguvium::Page}.
    #
    # Tables on those pages are neither extracted nor detected yet,
    # all the heavy lifting is done in {Iguvium::Page#extract_tables!} method.
    #
    # @param path [String] path to PDF file to be read
    # @option opts [String] :gspath (nil) explicit path to the GhostScript executable. Use it in case of
    #   non-standard gs executable placement. If not specified, gem tries standard options
    #   like `C:\\Program Files\\gs\\gs*\\bin\\gswin??c.exe` on Windows or just `gs` on Mac and Linux
    # @option opts [Logger::Level] :loglevel level like Logger::INFO, default is Logger::ERROR
    # @return [Array <Iguvium::Page>]
    #
    # @example prepare pages, consider images meaningful
    #   pages = Iguvium.read('filename.pdf', images: true)
    #
    # @example set nonstandard gs path, get pages starting with the one which contains keyword
    #   pages = Iguvium.read('nixon.pdf', gspath: '/usr/bin/gs')
    #   pages = pages.drop_while { |page| !page.text.match?(/Watergate/) }
    #   # {Iguvium::Page#text} does not require optical page scan and thus is relatively cheap.
    #   # It uses an underlying PDF::Reader::Page#text which is fast but not completely free though.
    #
    # @option opts [Boolean] :images (false) consider pictures in PDF as possible table separators.
    # This typically makes sense in a rare case when table grid in your pdf is filled with
    # rasterized texture or is actually a background picture. Usually you don't want to use it.
    #
    def read(path, **opts)
      if windows?
        unless opts[:gspath]
          gspath = Dir.glob('C:/Program Files/gs/gs*/bin/gswin??c.exe').first.tr('/', '\\')
          opts[:gspath] = "\"#{gspath}\""
        end

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

    # Creates and gives access to Ruby Logger. Default [Logger::Level] is Logger::ERROR.
    #
    # To set another level call `Iguvium.logger.level = Logger::INFO` or some other standard logger level
    #
    #
    # It is possible to redefine Iguvium's logger, for example to replace it with a global one like
    # `Iguvium.logger = Rails.logger`
    # @return [Logger]
    def logger
      return @logger if @logger

      @logger = Logger.new(STDOUT)
      @logger.formatter = proc do |severity, _, _, msg|
        "#{severity}: #{msg}\n"
      end
      @logger.level = Logger::ERROR
      @logger
    end
    def logger=(new_logger)
      @logger = new_logger
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
      RbConfig::CONFIG['host_os'].match(/mswin|mingw|cygwin/)
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
