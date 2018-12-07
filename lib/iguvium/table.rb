# frozen_string_literal: true

module Iguvium
  # Represents single table from the [Iguvium::Page]:
  # * table outer borders aka box,
  # * set of detected horizontal and vertical lines to form table's grid,
  # * set of characters with its coordinates to fill the grid.
  #
  # Additional functionality like an option to detect an open table grid at the end or at the beginning
  # of the page will be added later
  #
  # To render table into 2D text array, call {#to_a}
  class Table
    # @api private
    def initialize(box, page)
      @box = box
      @lines = page.lines
      @page = page
      grid
      heal
    end

    # Renders the table into an array of strings.
    #
    # Newlines in PDF have usually no semantic value, and are replaced with spaces by default.
    # Sometimes you may need to keep them; in this case use `newlines: true` option.
    #
    # @param  [Boolean] newlines keep newlines inside table cells, false by default
    # @param  [Boolean] phrases keep phrases unsplit, true by default.
    #   Poor man's merged cells workaround. Could break some tables , could fix some.
    #
    # @return [Array] 2D array of strings (content of table's cells)
    #
    def to_a(newlines: false, phrases: true)
      @to_a ||=
        grid[:rows]
        .reverse
        .map { |row|
          grid[:columns].map do |column|
            render(
              phrases ? words_inside(column, row) : chars_inside(column, row),
              newlines: newlines
            )
          end
        }
    end

    # def width
    #   grid[:columns].count
    # end

    # def mergeable?(other)
    #   width == other.width
    # end

    # def roofless?
    #   @roofless
    # end

    # def floorless?
    #   @floorless
    # end

    private

    attr_reader :page, :lines, :box

    # Looks if there are characters inside the box but outside of already detected cells
    # and adds rows and/or columns if necessary.
    # @return [Iguvium::Table] with added open-cell rows and columns
    def heal
      heal_rows
      heal_cols
      self
    end

    def wide_box
      @wide_box ||= [
        box.first.begin - 2..box.first.end + 2,
        box.last.begin - 2..box.last.end + 2
      ]
    end

    def heal_cols
      leftcol = box.first.begin..grid[:columns].first.begin
      rightcol = grid[:columns].last.end..box.first.end
      @grid[:columns].unshift(leftcol) if chars_inside(leftcol, box.last).any?
      @grid[:columns].append(rightcol) if chars_inside(rightcol, box.last).any?
    end

    def heal_rows
      # TODO: shrink box (like `box.last.end - 2`)
      roofrow = box.last.begin..grid[:rows].first.begin
      floorrow = grid[:rows].last.end..box.last.end
      if chars_inside(box.first, roofrow).any?
        @grid[:rows].unshift(roofrow)
        @roofless = true
      end
      if chars_inside(box.first, floorrow).any?
        @grid[:rows].append(floorrow)
        @floorless = true
      end
    end

    def characters
      xrange = box.first
      yrange = box.last
      @characters ||=
        page
        .characters
        .select { |character| xrange.cover?(character.x) && yrange.cover?(character.y) }
    end

    def words
      @words ||=
        characters
        .sort
        .chunk_while { |a, b| a.mergable?(b) }
        .map { |chunk| chunk.inject(:+) }
    end

    def words_inside(xrange, yrange)
      words.select { |character|
        xrange.cover?(character.x) && yrange.cover?(character.y)
      }
    end

    def grid
      return @grid if @grid

      @grid =
        {
          rows: lines_to_ranges(lines[:horizontal]),
          columns: lines_to_ranges(lines[:vertical])
        }
    end

    def lines_to_ranges(lines)
      # TODO: extend box for the sake of lines select
      lines.select { |line| line_in_box?(line, wide_box) }
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

    def render(characters, newlines: false)
      separator = newlines ? "\n" : ' '
      characters
        .sort
        .chunk_while { |a, b| a.mergable?(b) }
        .map { |chunk| chunk.inject(:+).to_s.strip.gsub(/[\s|\p{Z}]+/, ' ') }
        .join(separator)
        .gsub(/ +/, ' ')
    end
  end
end
