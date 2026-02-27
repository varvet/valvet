# frozen_string_literal: true

require_relative "lib/valvet/version"

Gem::Specification.new do |spec|
  spec.name = "valvet"
  spec.version = Valvet::VERSION
  spec.authors = ["Kim Burgestrand", "Varvet"]
  spec.email = ["kim@burgestrand.se"]

  spec.summary = "Encrypt secrets in your config files using asymmetric encryption"
  spec.description = "Keep secrets in your config files. Valvet encrypts sensitive values while leaving everything else readable, so you can check the whole file into version control. Uses NaCl sealed boxes via RbNaCl."
  spec.homepage = "https://github.com/varvet/valvet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/varvet/valvet"
  spec.metadata["changelog_uri"] = "https://github.com/varvet/valvet/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .standard.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "base64"
  spec.add_dependency "rbnacl"
  spec.add_dependency "zeitwerk"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
