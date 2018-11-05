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

  class CV
    def initialize(filepath, pagenumber = 1)
      @filepath = filepath
      @pagenumber = pagenumber
    end

    def recognize
      {
        lines: lines,
        boxes: boxes
      }
    end

    def lines
      @lines ||=
        {
          vertical: Labeler.new(verticals).lines.map { |line| flip_line line }.sort_by { |x, yrange| [yrange.begin, x] },
          horizontal: Labeler.new(horizontals).lines.map { |line| flip_line line }.sort_by { |xrange, y| [y] }
        }
    end

    def boxes
      @boxes ||= Labeler.new(
        image.pixels.map { |pix| 255 - pix }.each_slice(image.width).to_a
      ).clusters.map { |cluster| box cluster }.sort_by { |xrange, yrange| [yrange.begin, xrange.begin] }
    end

    private

    def verticals(treshold = 3)
      Matrix
        .rows(convolve(NArray[*horizontal_scan(image)], VERTICAL, 0).to_a)
        .map { |pix| pix < treshold ? nil : pix }
        .to_a
    end

    def horizontals(treshold = 3)
      Matrix
        .rows(convolve(NArray[*vertical_scan(image)], HORIZONTAL, 0).to_a)
        .map { |pix| pix < treshold ? nil : pix }
        .to_a
    end

    def image
      return @image if @image

      png = @filepath.gsub(/\.pdf$/, '.rgb')
      LOGGER.info `gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -dGraphicsAlphaBits=4 \
    -r72 -dFirstPage=#{@pagenumber} -dLastPage=#{@pagenumber} \
    -dFILTERTEXT -sOutputFile=#{png} #{@filepath} 2>&1`

      @image = ChunkyPNG::Image.from_file(png)
      File.delete png
      @image = blur @image
    end

    # START OF FLIPPER CODE
    def flip_y(coord)
      @height ||= @image.height
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
      blurred = convolve to_narray(image), GAUSS
      # TODO: Get rid of ChunkyPNG::Image on this stage completely
      blurred.to_a.each_with_index do |row, i|
        image.replace_row! i, row
      end
      image
    end

    def convolve(narray, conv, border_value = 255)
      narray = border(narray, conv.shape.first / 2, border_value)
      Convolver.convolve(narray, conv).round
    end

    def array_border(array, width, value = 0)
      hl = Array.new width, Array.new(array.first.count + width * 2, value)
      hl + array.map { |row| [value] * width + row + [value] * width } + hl
    end

    def border(narray, width, value = 0)
      NArray[*array_border(narray.to_a, width, value)]
    end

    def to_narray(image)
      NArray[
          image.pixels.map { |color|
            ChunkyPNG::Color.grayscale_teint ChunkyPNG::Color.compose(color, 0xffffffff)
          }
      ].reshape(image.width, image.height)
    end

    def minimums(ary)
      # TODO: #each_with_index is almost 1.7 slower than while loop
      ary.each_cons(2)
         .each_with_index
         .map { |(a, b), i| [i + 1, a <=> b] }
         .slice_when { |a, b| a.last != -1 && b.last == -1 }
         .map { |seq| seq.reverse.detect { |a| a.last == 1 }&.first }
         .compact
    end

    def edges(vector)
      Array
        .new(vector.count)
        .tap { |ary| minimums(vector).each { |i| ary[i] = 1 } }
    end

    # TODO: Get rid of Matrix in both scans
    def horizontal_scan(image)
      Array.new(image.height) { |row_index| edges(image.row(row_index)) }
    end

    def vertical_scan(image)
      Array.new(image.width) { |col_index| edges(image.column(col_index)) }.transpose
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
