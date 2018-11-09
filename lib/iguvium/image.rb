# frozen_string_literal: true

module Iguvium
  # PDF to image converter
  class Image
    # Prints single page without text to .rgb file and reads it back to memory
    #
    # @param path [String] path to PDF file to be read
    # @param pagenumber [Integer] number of page, first page is 1, not 0
    #
    # @option opts [Boolean] :images (false) consider pictures in PDF as possible table separators
    # @option opts [String] :gspath (nil) explicit path to the GhostScript executable. Use it in case of
    #   non-standard gs executable placement. If not specified, gem tries standard options
    #   like C:/Program Files/gs/gs*/bin/gswin??c.exe on Windows or just gs on Mac and Linux
    #
    # @return [ChunkyPNG::Image]
    def self.read(path, pagenumber = 1, **opts)
      rgb = path.gsub(/\.pdf$/, '.rgb')
      LOGGER.info `#{opts[:gspath]} -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -dGraphicsAlphaBits=4 \
    -r72 -dFirstPage=#{pagenumber} -dLastPage=#{pagenumber} \
    -dFILTERTEXT #{'-dFILTERIMAGE' unless opts[:images]} -sOutputFile=#{rgb} #{path} 2>&1`

      image = ChunkyPNG::Image.from_file(rgb)
      File.delete rgb
      image
    end
  end
end
