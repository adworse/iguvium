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

  THRESHOLD = 254

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
          vertical: Labeler.new(verticals).lines,
          horizontal: Labeler.new(horizontals).lines
        }
    end

    def boxes
      @boxes ||= Labeler.new(
        image.pixels.map { |pix| 255 - pix }.each_slice(image.width).to_a
      ).clusters.map { |cluster| box cluster }
    end

    private

    def verticals(treshold = 3)
      Matrix
        .rows(convolve(NArray[*horizontal_scan(image).to_a], VERTICAL, 0).to_a)
        .map { |pix| pix < treshold ? nil : pix }
        .to_a
    end

    def horizontals(treshold = 3)
      Matrix
        .rows(convolve(NArray[*vertical_scan(image).to_a], HORIZONTAL, 0).to_a)
        .map { |pix| pix < treshold ? nil : pix }
        .to_a
    end

    def image
      return @image if @image

      # TODO: switch to .rgb file format to speed things up

      png = @filepath.gsub(/\.pdf$/, '.png')
      LOGGER.info `gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pngalpha -dGraphicsAlphaBits=4 \
    -r72 -dFirstPage=#{@pagenumber} -dLastPage=#{@pagenumber} \
    -dFILTERTEXT -sOutputFile=#{png} #{@filepath} 2>&1`

      @image = ChunkyPNG::Image.from_file(png)
      @image.flip_horizontally! # to deal with the difference in zero coordinates with pdf
      File.delete png
      @image = blur @image
    end

    def blur(image)
      blurred = convolve to_narray(image), GAUSS
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
      # TODO: replace it with ghostscript grayscaling, test extensively
      image.grayscale!
      NArray[
          image.pixels.map { |color|
            ChunkyPNG::Color.grayscale_teint ChunkyPNG::Color.compose(color, 0xffffffff)
          }
      ].reshape(image.width, image.height)
    end

    def minimums(ary)
      ary.each_cons(2)
         .each_with_index
         .map { |(a, b), i| [i + 1, a <=> b] }
         .slice_when { |a, b| a.last != -1 && b.last == -1 }
         .map { |seq| seq.select { |a| a.last == 1 }.last&.first }
         .compact
    end

    def edges(vector)
      Array
        .new(vector.count)
        .tap { |ary| minimums(vector).each { |i| ary[i] = 1 } }
    end

    # TODO: This entire thresholding could probably be removed. It works fine with THRESHOLD = 254, so what's the sense?
    def brightness(color)
      color > THRESHOLD ? THRESHOLD : color
    end

    def horizontal_scan(image)
      Matrix.rows(
        image.height.times.map { |row_index|
          edges(image.row(row_index).map { |color| brightness color })
        }
      )
    end

    def vertical_scan(image)
      Matrix.rows image.width.times.map { |col_index|
        edges(image.column(col_index).map { |color| brightness color })
      }.transpose
    end

    def box(coord_array)
      ax, bx = coord_array.map(&:last).minmax
      ay, by = coord_array.map(&:first).minmax
      # TODO: To think about removing additional pixels from the box definition
      [ax - 1..bx + 1, ay - 1..by + 1]
    end
  end
end
