require "flutter_analyze_parser"

module Danger
  class DangerFlutterLint < Plugin
    # Enable only_modified_files
    # Only show messages within changed files.
    attr_accessor :only_modified_files

    def lint(inline_mode: false)
      if flutter_exists?
        violations = FlutterAnalyzeParser.violations(`flutter analyze`)
        flutter_lint(inline_mode: inline_mode, violations: violations)
      else
        fail("Could not find `flutter` inside current directory")
      end
    end

    private

    def flutter_lint(inline_mode:, violations: r)
      if inline_mode
        send_inline_comments(violations)
      else
        markdown(summary_table(violations))
      end
    end

    def send_inline_comments(violations)
      filtered_violations = filtered_violations(violations)

      filtered_violations.each do |violation|
        send("warn", violation.description, file: violation.file, line: violation.line)
      end
    end

    def summary_table(violations)
      filtered_violations = filtered_violations(violations)

      if filtered_violations.empty?
        return "### Flutter Analyze found #{filtered_violations.length} issues ✅"
      else
        return markdown_table(filtered_violations)
      end
    end

    def markdown_table(violations)
      table = "### Flutter Analyze found #{violations.length} issues ❌\n\n"
      table << "| File | Line | Rule |\n"
      table << "| ---- | ---- | ---- |\n"

      return violations.reduce(table) { |acc, violation| acc << table_row(violation) }
    end

    def table_row(violation)
      "| `#{violation.file}` | #{violation.line} | #{violation.rule} |\n"
    end

    def filtered_violations(violations)
      target_files = (git.modified_files - git.deleted_files) + git.added_files
      filtered_violations = violations.select { |violation| target_files.include? violation.file }

      return only_modified_files ? filtered_violations : violations
    end

    def flutter_exists?
      `which flutter`.strip.empty? == false
    end
  end
end
