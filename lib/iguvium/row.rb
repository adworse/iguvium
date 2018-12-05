# frozen_string_literal: true

module Iguvium

  class Row
    # gets characters limited by yrange and set of column ranges
    def initialize(columns, characters, phrases: true)
      @columns = columns
      if phrases
        characters =
          characters
          .sort
          .chunk_while { |a, b| a.mergable?(b) }
          .map { |chunk| chunk.inject(:+) }
      end
      @characters = characters
    end

    def cells
      @columns.map { |range|
        @characters.select { |character| range.cover?(character.x) }
      }
    end

    # @return rendered row array
    def render(newlines: false)
    end

    def merge(other)
    end
  end
end