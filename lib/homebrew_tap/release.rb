# frozen_string_literal: true

require_relative "error"

module HomebrewTap
  class Release
    OWNER = "gufranco"
    NAME = /\A[a-z0-9][a-z0-9-]*\z/
    TAG = /\Av?\d+(?:\.\d+)*\z/

    def self.version_of(tag)
      Gem::Version.new(tag.delete_prefix("v"))
    end

    attr_reader :name, :tag

    def initialize(name:, tag:)
      raise Error, "formula name required" if name.empty?
      raise Error, "tag required" if tag.empty?
      raise Error, "formula name #{name} is not a plain lowercase name" unless NAME.match?(name)
      raise Error, "tag #{tag} is not a release version" unless TAG.match?(tag)

      @name = name
      @tag = tag
      freeze
    end

    def repo
      "#{OWNER}/#{name}"
    end

    def homepage
      "https://github.com/#{repo}"
    end

    def version
      tag.delete_prefix("v")
    end

    def archive_url(base)
      "#{base}/#{repo}/archive/refs/tags/#{tag}.tar.gz"
    end
  end
end
