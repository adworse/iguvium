# frozen_string_literal: true

module Iguvium
  GAUSS = NArray[
      [0.0125786, 0.0251572, 0.0314465, 0.0251572, 0.0125786],
      [0.0251572, 0.0566038, 0.0754717, 0.0566038, 0.0251572],
      [0.0314465, 0.0754717, 0.0943396, 0.0754717, 0.0314465],
      [0.0251572, 0.0566038, 0.0754717, 0.0566038, 0.0251572],
      [0.0125786, 0.0251572, 0.0314465, 0.0251572, 0.0125786]
  ]

  HORIZONTAL = NArray[
      [-1, -1, -1],
      [2, 2, 2],
      [-1, -1, -1]
  ]

  VERTICAL = NArray[
      [-1, 2, -1],
      [-1, 2, -1],
      [-1, 2, -1]
  ]

  private_constant :GAUSS, :HORIZONTAL, :VERTICAL

  # Performs all the computer vision job except table composition.
  # Edge detection is performed using simplified two-directional version of
  # Canny edge detection operator applied to rows and columns as integer vectors
  class CV
    # @!attribute lines
    #   @return [Hash] :vertical and :horizontal lines. Horizontal lines are [Array<Range, Integer>],
    #     vertical have [Integer] on x position
    # @!attribute boxes
    #   @return [Array<Range, Range>] X range, Y range

    # Keeps recognized data
    Recognized = Struct.new(:lines, :boxes)

    # Prepares image for recognition: initial blur
    # @param image [ChunkyPNG::Image] from {Iguvium::Image.read}
    def initialize(image)
      @image = blur image
    end

    # @return [Array] 8-bit representation of an image
    attr_reader :image

    # @return [Recognized]
    #   lines most probably forming table cells and tables' outer borders as boxes
    def recognize
      Recognized.new(lines, boxes)
      # {
      #   lines: lines,
      #   boxes: boxes
      # }
    end

    private

    def lines
      @lines ||=
        {
          vertical: Labeler.new(verticals)
                           .lines
                           .map { |line| flip_line line }
                           .sort_by { |x, yrange| [yrange.begin, x] },
          horizontal: Labeler.new(horizontals).lines.map { |line| flip_line line }.sort_by { |_, y| [y] }
        }
    end

    def boxes
      return @boxes if @boxes

      brightest = image.flatten.max
      @boxes = Labeler.new(
        # image.map { |row| row.map { |pix| 255 - pix } }
        image.map { |row| row.map { |pix| pix < brightest } }
      ).clusters.map { |cluster| box cluster }.sort_by { |xrange, yrange| [yrange.begin, xrange.begin] }
    end

    def verticals(threshold = 3)
      Matrix
        .rows(convolve(NArray[*horizontal_scan(image)], VERTICAL, 0).to_a)
        .map { |pix| pix < threshold ? nil : pix }
        .to_a
    end

    def horizontals(threshold = 3)
      Matrix
        .rows(convolve(NArray[*vertical_scan(image)], HORIZONTAL, 0).to_a)
        .map { |pix| pix < threshold ? nil : pix }
        .to_a
    end

    # START OF FLIPPER CODE
    def flip_y(coord)
      @height ||= image.count
      @height - coord - 1
    end

    def flip_range(range)
      flip_y(range.end)..flip_y(range.begin)
    end

    def flip_line(line)
      y = line.last
      y = if y.is_a?(Numeric)
            flip_y y
          elsif y.is_a?(Range)
            flip_range y
          else
            raise ArgumentError, 'WTF?!'
          end

      [line.first, y]
    end

    # END OF FLIPPER CODE

    def blur(image)
      convolve(to_narray(image), GAUSS).to_a
    end

    def convolve(narray, conv, border_value = 255)
      narray = border(narray, conv.shape.first / 2, border_value)
      Convolver.convolve(narray, conv).ceil
    end

    def array_border(array, width, value = 0)
      hl = Array.new width, Array.new(array.first.count + width * 2, value)
      hl + array.map { |row| [value] * width + row + [value] * width } + hl
    end

    def border(narray, width, value = 0)
      NArray[*array_border(narray.to_a, width, value)]
    end

    def to_narray(image)
      palette = image.pixels.uniq
      # Precalculation looks stupid but spares up to 0.35 seconds on calculation depending on colorspace width
      dict = palette.zip(
        palette.map { |color| ChunkyPNG::Color.grayscale_teint ChunkyPNG::Color.compose(color, 0xffffffff) }
      ).to_h
      NArray[
        image.pixels.map { |color| dict[color] }
      ].reshape(image.width, image.height)
    end

    # def minimums_old(ary)
    #   ary.each_cons(2)
    #      .each_with_index
    #      .map { |(a, b), i| [i + 1, a <=> b] }
    #      .slice_when { |a, b| a.last != -1 && b.last == -1 }
    #      .to_a
    #      .map { |seq| seq.reverse.detect do |a| a.last == 1 end&.first }
    #      .compact
    # end

    def minimums(ary)
      # This ugly piece of code takes ~200 ms per page scan to run vs ~700 ms for the prettier old one
      i = 0
      mins = []
      local = 0
      while i + 2 < ary.length
        local = i + 1 if ary[i] > ary[i + 1]
        mins << local if ary[i] >= ary[i + 1] && ary[i + 1] < ary[i + 2]
        i += 1
      end
      mins.uniq
    end

    def edges(vector)
      Array
        .new(vector.count)
        .tap { |ary| minimums(vector).each { |i| ary[i] = 1 } }
    end

    def horizontal_scan(image)
      image.map { |row| edges row }
    end

    def vertical_scan(image)
      image.transpose.map { |row| edges row }.transpose
    end

    def box(coord_array)
      ax, bx = coord_array.map(&:last).minmax
      ay, by = coord_array.map(&:first).minmax
      # additional pixels removed from the box definition
      # [ax - 1..bx + 1, ay - 1..by + 1]
      [ax..bx, flip_range(ay..by)]
    end
  end
end
