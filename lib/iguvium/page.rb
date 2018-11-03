# frozen_string_literal: true

module Iguvium
  class Page
    def initialize(page, path)
      @reader_page = page
      @file = path
    end

    attr_reader :lines

    def extract_tables!
      return @tables if @tables

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
      recognized = CV.new(@file, @reader_page.number).recognize
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
