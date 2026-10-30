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
      pyproject = file { |parts| parts.size <= 2 && parts.last == "pyproject.toml" }
      return pyproject[PYPROJECT_VERSION, 1].to_s if pyproject

      core = file { |parts| parts.size <= 3 && parts.last(2) == %w[lib core.sh] }
      return core[SHELL_VERSION, 1].to_s if core

      raise Error, "the release archive has neither pyproject.toml nor lib/core.sh to read a version from"
    end

    private

    def file
      @files.find { |name, _contents| yield name.split("/") }&.last
    end
  end
end
