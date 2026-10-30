# frozen_string_literal: true

require_relative "error"
require_relative "formula_file"
require_relative "release_archive"

module HomebrewTap
  class FormulaBump
    def initialize(formula_dir:, archive_base:, out:)
      @formula_dir = formula_dir
      @archive_base = archive_base
      @out = out
      freeze
    end

    def bump(release)
      formula = owned_formula(release)
      newer = formula.tag_newer_than(release)
      if newer
        @out.puts("formula #{release.name} already points at #{newer}, newer than #{release.tag}")
      else
        point_at_release(formula, release)
      end
    end

    private

    def owned_formula(release)
      formula = FormulaFile.read(File.join(@formula_dir, "#{release.name}.rb"))
      return formula if formula.built_from?(release.homepage)

      raise Error, "formula #{release.name} is not built from #{release.repo}"
    end

    def point_at_release(formula, release)
      url = release.archive_url(@archive_base)
      archive = ReleaseArchive.download(url)
      packaged = archive.packaged_version
      if packaged != release.version
        raise Error, "the release is tagged #{release.tag} but the code in it says #{packaged}"
      end

      formula.pointed_at(url:, sha256: archive.sha256).save
      @out.puts("formula #{release.name} now points at #{release.tag}",
                "  url:    #{url}",
                "  sha256: #{archive.sha256}")
    end
  end
end
