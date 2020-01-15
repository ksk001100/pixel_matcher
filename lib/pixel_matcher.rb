require "pixel_matcher/version"
require 'pixel_matcher/diff_image'

module PixelMatcher
  class SizeMismatchError < StandardError
    def initialize(msg = 'Image size mismatch...')
      super
    end
  end

  class ModeMismatchError < StandardError
    def initialize(msg = 'Undefined mode...')
      super
    end
  end
end
