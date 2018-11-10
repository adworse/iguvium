# frozen_string_literal: true

module Iguvium
  # Dataset for the table and rules for it to render
  class Table
    # @param box [Array<Range, Range>] table outer borders
    # @param page [Iguvium::Page] entire page current table belongs to
    def initialize(box, page)
      @box = box
      @lines = page.lines
      @page = page
    end

    # After the table is extracted, you may render it to an array of strings.
    # Newlines in PDF have usually no semantic value, and are replaced with spaces by default.
    # Sometimes you need to keep them; in this case use `newlines: true` option.
    #
    # @option opts [Boolean] :newlines (false) keep newlines inside table cells
    # @return [Array] 2D array of strings (content of table's cells)
    #
    def to_a(**opts)
      @opts = opts
      grid[:rows]
        .reverse
        .map { |row| grid[:columns].map { |column| render chars_inside(column, row) } }
    end

    # @option (see #to_a)
    # @return [String] CSV
    def to_csv(**opts)
      to_a(opts).map(&:to_csv).join
    end

    private

    attr_reader :page, :lines, :box

    def enhancer(grid)
      # @todo write grid enhancer to detect cells between outer grid lines and box borders
    end

    def characters
      xrange = box.first
      yrange = box.last
      @characters ||=
        page
        .characters
        .select { |character| xrange.cover?(character.x) && yrange.cover?(character.y) }
    end

    def grid
      @grid ||=
        {
          rows: lines_to_ranges(lines[:horizontal]),
          columns: lines_to_ranges(lines[:vertical])
        }
    end

    def lines_to_ranges(lines)
      lines.select { |line| line_in_box?(line, box) }
           .map { |line| line.first.is_a?(Numeric) ? line.first : line.last }
           .sort
           .uniq
           .each_cons(2)
           .map { |a, b| a...b }
    end

    def line_in_box?(line, box)
      line = line.map { |coord| coord.is_a?(Range) ? coord.to_a.minmax : [coord] }
      (
      line.first.map { |coord| box.first.cover?(coord) } +
          line.last.map { |coord| box.last.cover?(coord) }
    ).all?
    end

    def chars_inside(xrange, yrange)
      characters.select { |character|
        xrange.cover?(character.x) && yrange.cover?(character.y)
      }
    end

    def render(characters)
      separator = @opts[:newlines] ? "\n" : ' '
      characters
        .sort
        .chunk_while { |a, b| a.mergable?(b) }
        .map { |chunk| chunk.inject(:+).to_s.strip.gsub(/[\s|\p{Z}]+/, ' ') }
        .join(separator)
        .gsub(/ +/, ' ')
    end
  end
end
