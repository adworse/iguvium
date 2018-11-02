# frozen_string_literal: true

require 'pdf-reader'

module Iguvium
  class Document
    def initialize(file)
      @file = file
      @doc = PDF::Reader.new(file)
      @pages =
        @doc
        .pages
        .each_index
        .map { |index| Page.new(self, index) }
    end

    attr_reader :file, :pages, :doc
  end

end
