# frozen_string_literal: true

module Iguvium
  # Keeps page data all together, calls image parser
  class Page
    # @param page [PDF::Reader::Page]
    # @param (see Iguvium.read)
    # @option (see Iguvium.read)
    def initialize(page, path, **opts)
      @opts = opts
      @reader_page = page
      @path = path
    end

    # @return (see Iguvium::CV#lines)
    attr_reader :lines

    # @return [Array<Iguvium::Table>]
    def extract_tables!(**opts)
      return @tables if @tables

      @opts.merge!(opts) if opts
      recognize!
      @tables
    end

    # @return [String] rendered page text, result of underlying PDF::Reader#text call
    def text
      @text ||= @reader_page.text
    end

    # @return [Array<PDF::Reader::TextRun>] array of characters on page. Each character has its coordinates,
    #   size, and width
    def characters
      return @characters if @characters

      receiver = PDF::Reader::PageTextReceiver.new
      @reader_page.send(:walk, receiver)
      @characters = receiver.instance_variable_get('@characters')
    end

    private

    def recognize!
      image = Image.read(@path, @reader_page.number, @opts)
      recognized = CV.new(image).recognize
      @lines = recognized[:lines]
      @boxes = recognized[:boxes].reject { |box| box_empty?(box) }
      @tables = @boxes.map { |box| Table.new(box, self) }.reverse
      self
    end

    def box_empty?(box)
      characters.select { |character|
        box.first.cover?(character.x) && box.last.cover?(character.y)
      }.empty?
    end
  end
end
