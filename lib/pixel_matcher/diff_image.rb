require 'rmagick'

module PixelMatcher
  class DiffImage < Magick::Image
    def initialize(original, changed)
      self.class.image_size_validate!(original, changed)

      @original = original
      @changed = changed
      super(@original.columns, @original.rows) { self.background_color = 'none' }
      store_diff
    end

    def self.from_path(path1, path2)
      original = Magick::Image.read(path1).first
      changed = Magick::Image.read(path2).first
      new(original, changed)
    end

    def self.from_blob(bin1, bin2)
      original = Magick::Image.from_blob(bin1).first
      changed = Magick::Image.from_blob(bin2).first
      new(original, changed)
    end

    def export(output_path, mode: :only)
      case mode
      when :only then export_diff(output_path)
      when :gray_scale then export_diff(output_path)
      when :compare then export_compare(output_path)
      else self.class.mode_validate!
      end
    end

    private

    def store_diff
      @original.columns.times do |i|
        @original.rows.times do |j|
          next if eq_pixel?(i, j)

          store_pixels(i, j, 1, 1, [@original.pixel_color(i, j)])
        end
      end
    end

    def eq_pixel?(column, row)
      @original.pixel_color(column, row) == @changed.pixel_color(column, row)
    end

    def export_diff(output_path)
      write(output_path)
      self
    end

    def export_gray_scale(output_path)
      gray_scale = @original.clone.quantize(256, Magick::GRAYColorspace)
      gray_scale.composite!(self, Magick::CenterGravity, 0, 0, Magick::OverCompositeOp)
      gray_scale.write(output_path)
      self
    end

    def export_compare(output_path)
      @changed.compare_channel(@original, Magick::MeanSquaredErrorMetric)
              .first
              .write(output_path)
      self
    end

    class << self
      def image_size_validate!(original, changed)
        return if [original.columns, original.rows] == [changed.columns, changed.rows]

        raise PixelMatcher::SizeMismatchError
      end

      def mode_validate!
        raise PixelMatcher::ModeMismatchError
      end
    end
  end
end
