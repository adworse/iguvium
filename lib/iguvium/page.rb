# frozen_string_literal: true

module Iguvium

  # It's document page, you can extract tables from here. to do so, use {Iguvium::Page#extract_tables!}.
  #
  # {Iguvium::Page#text} method is handy in order to pre-analyze whether you need this page.
  #
  # @example
  #   pages = Iguvium.read('nixon.pdf', gspath: '/usr/bin/gs')
  #   pages = pages.select { |page| page.text.match?(/[Tt]able.+\d+/) }
  #   tables = pages.map(&:extract_tables!)
  class Page
    # @param page [PDF::Reader::Page]
    # @param (see Iguvium.read)
    # Typically you don't need it, prefer {Page} creation from {Iguvium.read}
    def initialize(page, path, **opts)
      @opts = opts
      @reader_page = page
      @path = path
    end

    # @!visibility private
    # @return (see Iguvium::CV#lines)
    attr_reader :lines

    # This method does all the heavy lifting which include optical recognition of table borders.
    # It returns an array of {Iguvium::Table}
    # or an empty array if it fails to recognize any. To get structured data from parsed {Iguvium::Table},
    # just call {Iguvium::Table#to_a}.
    #
    # @todo Further speed improvements should be done, expecting at least 30% speedup on multicore systems
    #
    # Due to the nature of PDF document which is generally a collection of independent pages,
    # {Iguvium::Page#extract_tables!} is suitable for parallel processing. Concurrent processing
    # (think fork as parallel vs. thread as concurrent) on the other hand would be not a great idea,
    # because it's a CPU-intensive task.
    #
    # On some older CPUs it takes up to 2 seconds per page for it to work
    # (up to 1 second on more modern ones), so use it wisely.
    #
    # @example extract tables using pictures as possible borders
    #   tables = page.extract_tables! images: true #=> [Array<Iguvium::Table>]
    # @return [Array<Iguvium::Table>]
    def extract_tables!(images: @opts[:images])
      return @tables if @tables

      @opts[:images] = images
      recognize!
      @tables
    end

    # @return [String] rendered page text, result of underlying PDF::Reader::Page#text call
    # It takes ~150 ms for it to work, so it's handy
    # for picking up pages before trying to extract tables, which is an expensive operation
    def text
      @text ||= @reader_page.text
    end

    # @!visibility private
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
      # TODO: shrink box before test
      characters.select { |character|
        box.first.cover?(character.x) && box.last.cover?(character.y)
      }.empty?
    end
  end
end
