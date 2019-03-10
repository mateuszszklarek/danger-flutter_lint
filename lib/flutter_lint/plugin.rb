require "flutter_analyze_parser"

module Danger
  class DangerFlutterLint < Plugin
    def lint(inline_mode: false)
      unless flutter_exists?
        fail("Could not find `flutter` inside current directory")
        return
      end

      violations = FlutterAnalyzeParser.violations(`flutter analyze`)

      if inline_mode
        send_inline_comments(violations)
      else
        markdown(table_comments(violations))
      end
    end

    def table_comments(violations)
      filtered_violations = filtered_violations(violations)

      if filtered_violations.empty?
        return "### FlutterLint found #{filtered_violations.length} issues ✅"
      else
        return build_table(filtered_violations)
      end
    end

    def build_table(violations)
      table = "### FlutterLint found #{violations.length} issues ❌\n\n"
      table << "| File | Line | Rule |\n"
      table << "| ---- | ---- | ---- |\n"

      violations.each do |violation|
        table << "| `#{violation.file}` | #{violation.line} | #{violation.rule} |\n"
      end

      return table
    end

    def send_inline_comments(violations)
      filtered_violations = filtered_violations(violations)
      filtered_violations.each do |violation|
        send("warn", violation.description, file: violation.file, line: violation.line)
      end
    end

    def filtered_violations(violations)
      target_files = (git.modified_files - git.deleted_files) + git.added_files
      return violations.select { |violation| target_files.include? violation.file }
    end

    def flutter_exists?
      `which flutter`.strip.empty? == false
    end
  end
end
