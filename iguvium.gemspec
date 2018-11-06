# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iguvium/version'

Gem::Specification.new do |spec|
  spec.name          = 'iguvium'
  spec.version       = Iguvium::VERSION
  spec.authors       = ['Dima Ermilov']
  spec.email         = ['dima@scriptangle.com']

  spec.summary       = 'Extract tables from PDF as a structured info'
  spec.description   = 'Extract tables from PDF as a structured info. Uses ghostscript to print pdf to image, \
then recognizes table separators optically. No OpenCV or other heavy dependencies'
  spec.homepage      = 'https://github.com/adworse/iguvium'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  # spec.bindir        = 'exe'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.executables   = ['iguvium']

  spec.require_paths = ['lib']

  spec.add_dependency 'pdf-reader', '~> 2.1'
  spec.add_dependency 'convolver-light', '~> 0.3.1'
  spec.add_dependency 'oily_png', '~> 1.2'
  spec.add_dependency 'slop', '~> 4.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
