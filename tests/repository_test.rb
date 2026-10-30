# frozen_string_literal: true

require "yaml"
require "test_helper"

class RepositoryTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__).freeze
  READMES = ["README.md", "README.ja.md", "README.zh-Hans.md", "README.zh-HK.md"].freeze
  RUNS_A_DAY = 3
  HARDEN_RUNNER = "step-security/harden-runner@"
  FROZEN = "# frozen_string_literal: true\n"
  WORKFLOW_TRIGGERS = true
  FORBIDDEN_CASK_STANZA = /^\s*(?:container nested:|verified:|version :latest|sha256 :no_check)/

  def test_every_formula_and_cask_is_listed_in_every_readme
    # Arrange
    names = definitions("Formula") + definitions("Casks")

    # Act
    missing = READMES.flat_map { |readme| unlisted(readme, names) }

    # Assert
    assert_equal [], missing
  end

  def test_every_third_party_formula_has_a_scheduled_version_check
    # Arrange
    commands = run_commands("update-casks.yml")

    # Act
    unchecked = third_party_formulae.reject { |name| commands.any? { |run| run.include?("gufranco/tap/#{name}") } }

    # Assert
    assert_equal [], unchecked
  end

  def test_every_schedule_runs_three_times_a_day
    # Arrange
    crons = scheduled_crons + dependabot_crons

    # Act
    off_schedule = crons.reject { |cron| cron.split[1].split(",").size == RUNS_A_DAY }

    # Assert
    refute_empty crons
    assert_equal [], off_schedule
  end

  def test_every_job_has_a_timeout_and_hardens_the_runner_first
    # Arrange
    jobs = workflow_files.flat_map { |file| workflow(file)["jobs"].map { |name, job| ["#{file}:#{name}", job] } }

    # Act
    unbounded = jobs.reject { |_label, job| bounded_and_hardened?(job) }

    # Assert
    assert_equal [], unbounded.map(&:first)
  end

  def test_the_bot_merge_waits_for_every_pull_request_workflow
    # Arrange
    watched = workflow("bot-merge.yml")[WORKFLOW_TRIGGERS]["workflow_run"]["workflows"]

    # Act
    unwatched = pull_request_workflows - watched

    # Assert
    refute_empty watched
    assert_equal [], unwatched
  end

  def test_no_cask_declares_a_nested_container_a_verified_url_or_an_unpinned_download
    # Arrange
    files = Dir[File.join(ROOT, "Casks", "*.rb")]

    # Act
    offending = files.select { |file| File.read(file).match?(FORBIDDEN_CASK_STANZA) }

    # Assert
    refute_empty files
    assert_equal [], offending.map { |file| File.basename(file) }
  end

  def test_every_formula_and_cask_starts_with_frozen_string_literal
    # Arrange
    files = Dir[File.join(ROOT, "{Formula,Casks}", "*.rb")]

    # Act
    unfrozen = files.reject { |file| File.read(file).start_with?(FROZEN) }

    # Assert
    refute_empty files
    assert_equal [], unfrozen
  end

  private

  def definitions(folder)
    Dir[File.join(ROOT, folder, "*.rb")].map { |file| File.basename(file, ".rb") }
  end

  def unlisted(readme, names)
    text = File.read(File.join(ROOT, readme))
    names.reject { |name| text.include?("[#{name}](") }.map { |name| "#{readme}: #{name}" }
  end

  def third_party_formulae
    definitions("Formula").reject do |name|
      File.read(File.join(ROOT, "Formula", "#{name}.rb")).include?(%Q(  homepage "https://github.com/gufranco/#{name}"\n))
    end
  end

  def workflow_files
    Dir[File.join(ROOT, ".github", "workflows", "*.yml")].map { |file| File.basename(file) }
  end

  def workflow(file)
    YAML.load_file(File.join(ROOT, ".github", "workflows", file))
  end

  def scheduled_crons
    workflow_files.flat_map { |file| schedule_of(workflow(file)[WORKFLOW_TRIGGERS]) }.map { |entry| entry["cron"] }
  end

  def pull_request_workflows
    workflow_files.map { |file| workflow(file) }
                  .select { |spec| spec[WORKFLOW_TRIGGERS].key?("pull_request") }
                  .map { |spec| spec["name"] }
  end

  def schedule_of(triggers)
    triggers.is_a?(Hash) ? Array(triggers["schedule"]) : []
  end

  def dependabot_crons
    updates = YAML.load_file(File.join(ROOT, ".github", "dependabot.yml"))["updates"]
    updates.map { |update| update["schedule"]["cronjob"] }
  end

  def run_commands(file)
    workflow(file)["jobs"].values.flat_map { |job| job["steps"] }.filter_map { |step| step["run"] }
  end

  def bounded_and_hardened?(job)
    job["timeout-minutes"] && job["steps"].first["uses"].to_s.start_with?(HARDEN_RUNNER)
  end
end
