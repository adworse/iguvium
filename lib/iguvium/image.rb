module Iguvium
  class Image
    def self.read(path, pagenumber = 1, **opts)
      rgb = path.gsub(/\.pdf$/, '.rgb')
      LOGGER.info `gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -dGraphicsAlphaBits=4 \
    -r72 -dFirstPage=#{pagenumber} -dLastPage=#{pagenumber} \
    -dFILTERTEXT #{'-dFILTERIMAGE' unless opts[:images]} -sOutputFile=#{rgb} #{path} 2>&1`

      image = ChunkyPNG::Image.from_file(rgb)
      File.delete rgb
      image
    end
  end
end