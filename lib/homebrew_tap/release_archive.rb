# frozen_string_literal: true

require "digest"
require "open3"
require "rubygems/package"
require "stringio"
require "zlib"
require_relative "error"

module HomebrewTap
  class ReleaseArchive
    PYPROJECT_VERSION = Regexp.new('^version = "(.*)"$').freeze
    HATCH_VERSION_TABLE = /^\[tool\.hatch\.version\]$(.*?)(?=^\[|\z)/m
    HATCH_DEFAULT_PATTERN = Regexp.new(%q{^(?:__version__|VERSION) *= *(?<quote>['"])v?(?<version>.+?)\k<quote>},
                                       Regexp::IGNORECASE).freeze
    TOML_STRING = %q{ *= *("(?:[^"\\\\]|\\\\.)*"|'[^']*') *$}
    SHELL_VERSION = Regexp.new('^[A-Z][A-Z0-9_]*_VERSION="([0-9][^"]*)"$').freeze
    CURL = %w[curl --fail --silent --show-error --location --retry 5 --retry-all-errors].freeze

    def self.download(url)
      body, _error, status = Open3.capture3(*CURL, url, binmode: true)
      raise Error, "could not download #{url}" unless status.success?

      new(body)
    end

    def self.files_in(body)
      Zlib::GzipReader.wrap(StringIO.new(body)) do |gzip|
        Gem::Package::TarReader.new(gzip).filter_map { |entry| [entry.full_name, entry.read.to_s] if entry.file? }
      end
    rescue Zlib::Error, Gem::Package::TarInvalidError => e
      raise Error, "the release archive is not a gzip tarball: #{e.message}"
    end

    attr_reader :sha256

    def initialize(body)
      @sha256 = Digest::SHA256.hexdigest(body)
      @files = ReleaseArchive.files_in(body)
      freeze
    end

    def packaged_version
      pyproject_name, pyproject = entry { |parts| parts.size <= 2 && parts.last == "pyproject.toml" }
      return pyproject_version(pyproject_name, pyproject) if pyproject

      _name, core = entry { |parts| parts.size <= 3 && parts.last(2) == %w[lib core.sh] }
      return core[SHELL_VERSION, 1].to_s if core

      raise Error, "the release archive has neither pyproject.toml nor lib/core.sh to read a version from"
    end

    private

    def pyproject_version(name, pyproject)
      static = pyproject[PYPROJECT_VERSION, 1]
      return static if static

      table = pyproject[HATCH_VERSION_TABLE, 1]
      path = table && toml_string(table, "path")
      return "" unless path

      hatch_version(name.split("/")[0...-1] + path.split("/"), path, toml_string(table, "pattern"))
    end

    def hatch_version(parts, path, pattern)
      _name, source = entry { |candidate| candidate == parts }
      unless source
        raise Error, "pyproject.toml reads its version from #{path}, which the release archive does not have"
      end

      source[pattern ? ruby_regexp(pattern) : HATCH_DEFAULT_PATTERN, "version"].to_s
    end

    def ruby_regexp(python_pattern)
      Regexp.new(python_pattern.gsub("(?P<", "(?<").gsub(/\(\?P=(\w+)\)/, '\k<\1>'))
    end

    def toml_string(table, key)
      raw = table[Regexp.new("^#{key}#{TOML_STRING}"), 1]
      return unless raw

      raw.start_with?("'") ? raw[1...-1] : raw.undump
    end

    def entry
      @files.find { |name, _contents| yield name.split("/") }
    end
  end
end
