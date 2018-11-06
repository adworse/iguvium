# frozen_string_literal: true

module Iguvium
  class Page
    def initialize(page, path, **opts)
      @opts = opts
      @reader_page = page
      @file = path
    end

    attr_reader :lines

    def extract_tables!(**opts)
      return @tables if @tables

      @opts.merge!(opts) if opts
      recognize!
      @tables
    end

    def text
      @text ||= @reader_page.text
    end

    def characters
      return @characters if @characters

      receiver = PDF::Reader::PageTextReceiver.new
      @reader_page.send(:walk, receiver)
      @characters = receiver.instance_variable_get('@characters')
    end

    private

    def recognize!
      image = Image.read(@file, @reader_page.number, @opts)
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
