require 'rmagick'

module PixelMatcher
  class DiffImage < Magick::Image
    def initialize(img1, img2)
      self.class.image_size_validate(img1, img2)
      @img1 = img1
      @img2 = img2
      super(@img1.columns, @img1.rows) { self.background_color = 'none' }
      store_diff
    end

    def self.from_path(path1, path2)
      img1 = Magick::Image.read(path1).first
      img2 = Magick::Image.read(path2).first
      new(img1, img2)
    end

    def self.from_blob(bin1, bin2)
      img1 = Magick::Image.from_blob(bin1).first
      img2 = Magick::Image.from_blob(bin2).first
      new(img1, img2)
    end

    def self.image_size_validate(img1, img2)
      return if [img1.columns, img1.rows] == [img2.columns, img2.rows]

      raise PixelMatcher::SizeMismatchError, 'Image size mismatch'
    end

    def export_diff(output_path)
      write(output_path)
      self
    end

    def export_gray_scale(output_path)
      gray_scale = @img1.clone.quantize(256, Magick::GRAYColorspace)
      gray_scale.composite!(self, Magick::CenterGravity, 0, 0, Magick::OverCompositeOp);
      gray_scale.write(output_path)
      self
    end

    private

    def store_diff
      @img1.columns.times do |i|
        @img1.rows.times do |j|
          store_pixels(i, j, 1, 1, [@img1.pixel_color(i, j)]) unless eq_pixel?(i, j)
        end
      end
    end

    def eq_pixel?(i, j)
      @img1.pixel_color(i, j) == @img2.pixel_color(i, j)
    end
  end
end
