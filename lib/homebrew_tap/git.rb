# frozen_string_literal: true

require "open3"
require_relative "error"

module HomebrewTap
  class Git
    PLAIN_LOCALE = { "LC_ALL" => "C" }.freeze

    def initialize(dir:, env: {})
      @dir = dir
      @env = PLAIN_LOCALE.merge(env).freeze
      freeze
    end

    def run(*args)
      output, status = capture(args)
      raise Error, "git #{args.join(" ")} failed: #{output.strip}" unless status.success?

      output
    end

    def ok?(*args)
      capture(args).last.success?
    end

    private

    def capture(args)
      Open3.capture2e(@env, "git", "-C", @dir, *args)
    end
  end
end
