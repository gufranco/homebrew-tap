# frozen_string_literal: true

require "json"

class FakeGh
  ALREADY_MERGED = "GraphQL: Pull Request is already merged (mergePullRequest)"

  def initialize(state_path)
    @state_path = state_path
  end

  def call(args)
    File.open(@state_path, File::RDWR) do |file|
      file.flock(File::LOCK_EX)
      state = JSON.parse(file.read)
      code = dispatch(state, args)
      file.rewind
      file.truncate(0)
      file.write(JSON.generate(state))
      code
    end
  end

  private

  def dispatch(state, args)
    case args.first(2)
    in ["pr", "list"] then list(state, flags(args.drop(2)))
    in ["pr", "view"] then view(state, args[2])
    in ["pr", "merge"] then merge(state, args[2], flags(args.drop(3)))
    else
      warn("unknown command: #{args.join(" ")}")
      2
    end
  end

  def flags(args)
    args.slice_before { |arg| arg.start_with?("--") }.to_h { |name, value = true| [name, value] }
  end

  def list(state, options)
    fields = options["--json"].split(",")
    pulls = state["pulls"].select do |pull|
      pull["headRefName"] == options["--head"] && pull["state"] == options["--state"].upcase
    end
    puts(JSON.generate(pulls.map { |pull| pull.slice(*fields) }))
    0
  end

  def view(state, number)
    puts(JSON.generate(pull(state, number).slice("state")))
    0
  end

  def merge(state, number, options)
    found = pull(state, number)
    refusal = merge_refusal(found, options)
    if refusal
      found["state"] = "MERGED" if found["mergedElsewhere"]
      warn(refusal)
      return 1
    end

    found["state"] = "MERGED"
    state["merges"] << { "number" => found["number"], "subject" => options["--subject"],
                         "body" => options["--body"], "squash" => options["--squash"] }
    0
  end

  def merge_refusal(found, options)
    return ALREADY_MERGED if found["state"] == "MERGED" || found["mergedElsewhere"]
    return "Pull request is not mergeable: the merge commit cannot be cleanly created." if found["conflicting"]

    "head commit mismatch" if found["headRefOid"] != options["--match-head-commit"]
  end

  def pull(state, number)
    state["pulls"].find { |candidate| candidate["number"].to_s == number }
  end
end

exit(FakeGh.new(ARGV.shift).call(ARGV))
