require 'rmagick'

module PixelMatcher
  class DiffImage < Magick::Image
    def initialize(path1, path2)
      img1 = image_array(path1)
      img2 = image_array(path2)
      super(img1.last[1], img1.last[2])
      store_diff(img1, img2)
    end

    def export(output_path)
      write(output_path)
    end

    private

    def store_diff(arr1, arr2)
      arr1.zip(arr2) do |a1, a2|
        store_pixels(a1[1], a1[2], 1, 1, [a1[0]]) if (a1[0] <=> a2[0]) != 0
      end
    end

    def image_array(path)
      [].tap do |arr|
        Magick::Image.read(path).first.each_pixel do |pixel, c, r|
          arr << [pixel, c, r]
        end
      end
    end
  end
end
