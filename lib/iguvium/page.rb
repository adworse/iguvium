# frozen_string_literal: true

module Iguvium

  # It's document page. To extract tables, use {Iguvium::Page#extract_tables!}. {PDF::Reader::Page} inside
  # {Iguvium::Page} object provides {Iguvium::Page#text} method. It takes ~150 ms for it to work, so it's handy
  # for picking up pages before trying to extract tables, which is an expensive operation
  # @example
  #   pages = Iguvium.read('nixon.pdf', gspath: '/usr/bin/gs')
  #   pages = pages.select { |page| page.text.match?(/[Tt]able.+\d+/) }
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

    # This method does all the heavy lifting. On some older CPUs it takes up to 2 seconds per page for it to work
    # (up to 1 second on more modern ones), so use it with caution. It returns an array of {Iguvium::Table}
    # or an empty array if it fails to recognize any. To get structured data from parsed {Iguvium::Table},
    # just call {Iguvium::Table#to_a} or {Iguvium::Table#to_csv}. It's possible to explicitely overwrite
    # global :images option.
    # @todo Further speed improvements should be done, expecting at least 30% speedup on multicore systems
    # @note Due to the nature of PDF document which is generally a collection of independent pages,
    # {Iguvium::Page#extract_tables!} is suitable for parallel processing. Concurrent processing
    # (think fork vs. thread) on the other hand would be not a great idea, because it's a CPU-intensive task.
    # @example extract tables using pictures as possible borders
    #   tables = page.extract_tables! images: true #=> [Array<Iguvium::Table>]
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
