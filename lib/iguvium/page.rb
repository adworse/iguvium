# frozen_string_literal: true

module Iguvium
  class Page
    def initialize(doc, index)
      @reader_page = doc.doc.pages[index]
      @page_number = index + 1
      @file = doc.file
    end

    attr_reader :lines

    def tables
      return @tables if @tables

      recognize!
      @tables
    end

    def text
      @text ||= @reader_page.text
    end

    def recognize!
      recognized = CV.new(@file, @page_number).recognize
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

    def characters
      return @characters if @characters

      receiver = PDF::Reader::PageTextReceiver.new
      @reader_page.send(:walk, receiver)
      @characters = receiver.instance_variable_get('@characters')
    end
  end
end
