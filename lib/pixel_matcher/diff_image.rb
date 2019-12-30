require 'rmagick'

class PixelMatcher::DiffImage < Magick::Image
  def initialize(path1, path2)
    img1 = [].tap do |arr|
      Magick::Image.read(path1).first.each_pixel do |pixel, c ,r|
        arr << [pixel, c, r]
      end
    end
    
    img2 = [].tap do |arr|
      Magick::Image.read(path2).first.each_pixel do |pixel, c ,r|
        arr << [pixel, c, r]
      end
    end

    super(img1.last[1], img1.last[2])

    img1.zip(img2) do |i1, i2|
      if (i1[0] <=> i2[0]) != 0
        self.store_pixels(i1[1], i1[2], 1, 1, [i1[0]])
      end
    end
  end

  def export(output_path)
    self.write(output_path)
  end
end