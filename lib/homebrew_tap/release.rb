# frozen_string_literal: true

require_relative "error"

module HomebrewTap
  class Release
    OWNER = "gufranco"
    NAME = /\A[a-z0-9][a-z0-9-]*\z/
    TAG = /\Av?\d+(?:\.\d+)*\z/
    ASSET = /\A[a-z0-9][a-z0-9._-]*\.tar\.gz\z/

    def self.version_of(tag)
      Gem::Version.new(tag.delete_prefix("v"))
    end

    attr_reader :name, :tag, :asset

    def initialize(name:, tag:, asset: "")
      raise Error, "formula name required" if name.empty?
      raise Error, "tag required" if tag.empty?
      raise Error, "formula name #{name} is not a plain lowercase name" unless NAME.match?(name)
      raise Error, "tag #{tag} is not a release version" unless TAG.match?(tag)
      raise Error, "asset #{asset} is not a plain archive name" if !asset.empty? && !ASSET.match?(asset)

      @name = name
      @tag = tag
      @asset = asset
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
      return "#{base}/#{repo}/archive/refs/tags/#{tag}.tar.gz" if asset.empty?

      "#{base}/#{repo}/releases/download/#{tag}/#{asset}"
    end
  end
end
