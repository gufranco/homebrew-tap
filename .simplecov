SimpleCov.start do
  merge_timeout 3600
  minimum_coverage line: Integer(ENV.fetch("COVERAGE_MINIMUM", "0"))
  add_filter "test/"
  add_filter "coverage/"
  add_filter "vendor/"
  add_filter "scripts/coverage.sh"
end
