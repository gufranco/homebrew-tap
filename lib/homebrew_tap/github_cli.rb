# frozen_string_literal: true

require "open3"
require_relative "error"

module HomebrewTap
  class GitHubCli
    GH = ["gh"].freeze

    def initialize(command: GH)
      @command = command.dup.freeze
      freeze
    end

    def run(*args)
      output, error, status = Open3.capture3(*@command, *args)
      raise Error, "gh #{args.first(2).join(" ")} failed: #{error.strip}" unless status.success?

      output
    end
  end
end
