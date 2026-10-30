# frozen_string_literal: true

require_relative "error"
require_relative "release"

module HomebrewTap
  class FormulaFile
    TAGGED_URL = Regexp.new('^ *url ".*/archive/refs/tags/(v?\d+(?:\.\d+)*)\.tar\.gz"$').freeze
    URL = Regexp.new('url "[^"]+"').freeze
    CHECKSUM = Regexp.new('sha256 "[0-9a-f]{64}"').freeze

    def self.read(path)
      raise Error, "no formula at #{path}" unless File.file?(path)

      new(path:, text: File.read(path))
    end

    attr_reader :path, :text

    def initialize(path:, text:)
      @path = path
      @text = text
      freeze
    end

    def built_from?(homepage)
      text.each_line(chomp: true).include?(%Q(  homepage "#{homepage}"))
    end

    def tag_newer_than(release)
      current = text[TAGGED_URL, 1]
      return if current.nil? || current == release.tag

      current if Release.version_of(current) >= Release.version_of(release.tag)
    end

    def pointed_at(url:, sha256:)
      rewritten = text.sub(URL, %Q(url "#{url}")).sub(CHECKSUM, %Q(sha256 "#{sha256}"))
      FormulaFile.new(path:, text: rewritten)
    end

    def save
      staged = "#{path}.#{Process.pid}.#{Thread.current.object_id}.tmp"
      File.write(staged, text)
      File.rename(staged, path)
    end
  end
end
