require 'rmagick'

module PixelMatcher
  class DiffImage
    def initialize(img1, img2)
      @img1 = img1
      @img2 = img2
      @gray_scale = @img1.clone.quantize(256, Magick::GRAYColorspace)
      @diff = Magick::Image.new(@img1.columns, @img1.rows)
    end

    def self.from_path(path1, path2)
      img1 = Magick::Image.read(path1).first
      img2 = Magick::Image.read(path2).first
      self.new(img1, img2)
    end

    def self.from_blob(bin1, bin2)
      img1 = Magick::Image.from_blob(bin1).first
      img2 = Magick::Image.from_blob(bin2).first
      self.new(img1, img2)
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
          @diff.store_pixels(i, j, 1, 1, [@img1.pixel_color(i, j)]) unless eq_pixel?(i, j)
        end
      end
    end

    def store_gray_scale_diff
      @img1.columns.times do |i|
        @img1.rows.times do |j|
          @gray_scale.store_pixels(i, j, 1, 1, [@img1.pixel_color(i, j)]) unless eq_pixel?(i, j)
        end
      end
    end

    def eq_pixel?(i, j)
      @img1.pixel_color(i, j) == @img2.pixel_color(i, j)
    end
  end
end
