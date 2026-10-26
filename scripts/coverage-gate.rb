require "json"

ARTIFACT = /\A\s*(done\s*<.*|[^()\s]+\)\s*;;|\)(\s+\S*>\S*)*\s*&?)\s*\z/

def relative_key(file, pattern)
  match = file.match(pattern)
  match && file[(match.begin(0) + 1)..]
end

def add_counts(merged, key, counts)
  lines = merged[key] ||= Array.new(counts.length)
  counts.each_with_index do |count, index|
    lines[index] = (lines[index] || 0) + count unless count.nil?
  end
end

def merged_lines(paths, pattern)
  merged = {}
  paths.each do |path|
    JSON.parse(File.read(path)).each_value do |run|
      run.fetch("coverage").each do |file, data|
        key = relative_key(file, pattern)
        add_counts(merged, key, data.is_a?(Hash) ? data.fetch("lines") : data) if key
      end
    end
  end
  merged
end

def relevant_lines(key, counts)
  source = File.readlines(key, chomp: true)
  counts.each_with_index.reject { |count, index| count.nil? || source[index].to_s.match?(ARTIFACT) }
        .map { |count, index| [index + 1, count, source[index].strip] }
end

pattern, minimum, *paths = ARGV
merged = merged_lines(paths, Regexp.new(pattern))
abort("no covered files match #{pattern}") if merged.empty?

lines = merged.flat_map { |key, counts| relevant_lines(key, counts).map { |entry| [key, *entry] } }
misses = lines.select { |_key, _number, count, _text| count.zero? }
misses.each { |key, number, _count, text| puts "#{key}:#{number}: #{text}" }
percent = lines.empty? ? 100.0 : 100.0 * (lines.length - misses.length) / lines.length
puts format("covered %d of %d lines (%.2f%%), gate %.2f%%", lines.length - misses.length, lines.length, percent, Float(minimum))
exit(percent + 1e-9 < Float(minimum) ? 1 : 0)
