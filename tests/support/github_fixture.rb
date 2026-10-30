# frozen_string_literal: true

require "fileutils"
require "json"
require "rbconfig"
require "tmpdir"

class GitHubFixture
  FAKE = File.expand_path("fake_gh.rb", __dir__).freeze
  TAP_BOT = "app/gufranco-tap-bot"

  attr_reader :repo, :root

  def initialize
    @root = Dir.mktmpdir("homebrew-tap-github")
    @state = File.join(root, "state.json")
    @repo = "gufranco/#{Faker::Internet.slug(glue: "-")}"
    File.write(@state, JSON.generate("pulls" => [], "merges" => []))
  end

  def command
    [RbConfig.ruby, FAKE, @state]
  end

  def open_pull(checks:, author: TAP_BOT, title: bump_title, **flags)
    state = read
    pull = {
      "number" => state["pulls"].size + 1, "title" => title, "author" => { "login" => author },
      "headRefName" => "bump-#{Faker::Internet.slug(glue: "-")}", "headRefOid" => Faker::Crypto.sha1,
      "state" => "OPEN", "statusCheckRollup" => checks, "isCrossRepository" => false
    }.merge(flags)
    state["pulls"] << pull
    File.write(@state, JSON.generate(state))
    pull
  end

  def check_run(name, conclusion: "SUCCESS", status: "COMPLETED")
    { "__typename" => "CheckRun", "name" => name, "status" => status, "conclusion" => conclusion }
  end

  def status_context(context, state: "SUCCESS")
    { "__typename" => "StatusContext", "context" => context, "state" => state }
  end

  def merges
    read["merges"]
  end

  def bin_dir
    dir = File.join(root, "bin")
    FileUtils.mkdir_p(dir)
    gh = File.join(dir, "gh")
    File.write(gh, "#!/bin/sh\nexec #{command.map { |part| "'#{part}'" }.join(" ")} \"$@\"\n")
    File.chmod(0755, gh)
    dir
  end

  def remove
    FileUtils.rm_rf(root)
  end

  private

  def bump_title
    "#{Faker::Internet.slug(glue: "-")} #{Faker::App.semantic_version}"
  end

  def read
    JSON.parse(File.read(@state))
  end
end
