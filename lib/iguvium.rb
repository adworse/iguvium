# frozen_string_literal: true

require 'convolver-light'
require 'csv'
require 'fileutils'
require 'matrix'
require 'oily_png'
require 'pdf-reader'

require_relative 'iguvium/labeler'
require_relative 'iguvium/cv'
require_relative 'iguvium/document'
require_relative 'iguvium/page'
require_relative 'iguvium/table'
require_relative 'iguvium/version'

module Iguvium
  def self.read(path)
    PDF::Reader.new(path)
               .pages
               .map { |page| Page.new(page, path) }
    # Document.new(path).pages
  end
end

# TODO: 3) The gem is annoyingly slow. I have some ideas how to deal with it, and speed things up at least a couple of times,
# but it can break something unpleasantly, so extensive tests should be added.
#
# TODO: 4) Add options like 'print' with images or with generated graphics only, gs executable path, and maybe image thresholding

# 5) This will make it version 0.8. Some options, faster than now but still basic
#
# TODO: 6) 0.9 - version capable of reading tables with open outer cells, like this:
# __|____|_______|_____|
# __|____|_______|_____|
# __|____|_______|_____|
#
# TODO: 7) 1.0 - in addition it should deal with merged cells (placing result to the upper left cell on the grid).
