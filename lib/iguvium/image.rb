module Iguvium
  class Image
    def self.read(path, pagenumber = 1)
      png = path.gsub(/\.pdf$/, '.rgb')
      LOGGER.info `gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -dGraphicsAlphaBits=4 \
    -r72 -dFirstPage=#{pagenumber} -dLastPage=#{pagenumber} \
    -dFILTERTEXT -sOutputFile=#{png} #{path} 2>&1`

      image = ChunkyPNG::Image.from_file(png)
      File.delete png
      image
    end
  end
end