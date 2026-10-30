# frozen_string_literal: true

require "fileutils"
require "rubygems/package"
require "stringio"
require "tmpdir"
require "zlib"

class TapFixture
  UNSET_SHA256 = "0" * 64

  attr_reader :root, :name

  def initialize(name: Faker::Internet.slug(glue: "-"))
    @name = name
    @root = Dir.mktmpdir("homebrew-tap-test")
    FileUtils.mkdir_p([formula_dir, archives_dir])
  end

  def formula_dir
    File.join(root, "Formula")
  end

  def archive_base
    "file://#{archives_dir}"
  end

  def formula_path
    File.join(formula_dir, "#{name}.rb")
  end

  def formula_text
    File.read(formula_path)
  end

  def tagged_url(tag)
    "https://github.com/gufranco/#{name}/archive/refs/tags/#{tag}.tar.gz"
  end

  def write_formula(tag:, homepage: "https://github.com/gufranco/#{name}", url: tagged_url(tag))
    File.write(formula_path, formula_source(homepage:, url:, sha256: UNSET_SHA256))
  end

  def formula_source(url:, sha256:, homepage: "https://github.com/gufranco/#{name}")
    <<~RUBY
      class Sample < Formula
        desc "Sample formula the bump rewrites"
        homepage "#{homepage}"
        url "#{url}"
        sha256 "#{sha256}"
        license "MIT"
      end
    RUBY
  end

  def publish_release(tag:, files:)
    publish_bytes(tag:, bytes: Zlib.gzip(tarball("#{name}-#{tag.delete_prefix("v")}", files)))
  end

  def publish_bytes(tag:, bytes:)
    path = archive_path(tag)
    FileUtils.mkdir_p(File.dirname(path))
    File.binwrite(path, bytes)
    path
  end

  def archive_path(tag)
    File.join(archives_dir, "gufranco", name, "archive", "refs", "tags", "#{tag}.tar.gz")
  end

  def remove
    FileUtils.rm_rf(root)
  end

  private

  def archives_dir
    File.join(root, "archives")
  end

  def tarball(top, files)
    tar = StringIO.new(String.new(encoding: Encoding::BINARY))
    Gem::Package::TarWriter.new(tar) do |writer|
      writer.mkdir(top, 0755)
      files.each { |relative, contents| add_file(writer, File.join(top, relative), contents) }
    end
    tar.string
  end

  def add_file(writer, path, contents)
    folder = File.dirname(path)
    writer.mkdir(folder, 0755) if folder.include?("/")
    writer.add_file_simple(path, 0644, contents.bytesize) { |io| io.write(contents) }
  end
end
