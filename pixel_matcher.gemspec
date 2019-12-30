lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pixel_matcher/version"

Gem::Specification.new do |spec|
  spec.name          = "pixel_matcher"
  spec.version       = PixelMatcher::VERSION
  spec.authors       = ["ksk001100"]
  spec.email         = ["hm.pudding0715@gmail.com"]

  spec.summary       = %q{Library to compare images and generate difference image files}
  spec.description   = %q{Library to compare images and generate difference image files}
  spec.homepage      = "https://github.com/ksk001100/pixel_matcher"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rmagick", "~> 4.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', '~> 0.12.2'
end
