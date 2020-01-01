require 'rmagick'

module PixelMatcher
  class DiffImage < Magick::Image
    def initialize(path1, path2)
      @img1 = Magick::Image.read(path1).first
      @img2 = Magick::Image.read(path2).first
      @gray_scale = @img1.clone.quantize(256, Magick::GRAYColorspace)
      @diff = Magick::Image.new(@img1.columns, @img1.rows)
    end

    def export_diff(output_path)
      store_diff
      @diff.write(output_path)
      self
    end

    def export_gray_scale(output_path)
      store_gray_scale_diff
      @gray_scale.write(output_path)
      self
    end

    private

    def store_diff
      @img1.columns.times do |i|
        @img1.rows.times do |j|
          @diff.store_pixels(i, j, 1, 1, [@img1.pixel_color(i, j)]) unless eq_pixel?(@img1, @img2, i, j)
        end
      end
    end

    def store_gray_scale_diff
      @img1.columns.times do |i|
        @img1.rows.times do |j|
          @gray_scale.store_pixels(i, j, 1, 1, [@img1.pixel_color(i, j)]) unless eq_pixel?(@img1, @img2, i, j)
        end
      end
    end
  end
end

def image_array(img)
  img.export_pixels.each_slice(3).each_slice(img.columns).to_a
end

def eq_pixel?(img1, img2, i, j)
  img1.pixel_color(i, j) == img2.pixel_color(i, j)
end
