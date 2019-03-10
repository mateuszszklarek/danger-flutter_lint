require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerFlutterLint do
    it "should be a danger plugin" do
      expect(Danger::DangerFlutterLint.new(nil)).to be_a Danger::Plugin
    end

    describe "with a Dangerfile" do
    	before do
    		@dangerfile = testing_dangerfile
    		@flutter_lint = @dangerfile.flutter_lint
    		allow(@flutter_lint.git).to receive(:deleted_files).and_return([])
        allow(@flutter_lint.git).to receive(:added_files).and_return([])
        allow(@flutter_lint.git).to receive(:modified_files).and_return([
          "lib/home/home_page.dart",
          "lib/profile/user/phone_widget.dart"
        ])
    	end

    	context "when flutter is not installed" do
    		before do
    			allow(@flutter_lint).to receive(:`).with("which flutter").and_return("")
    		end

    		it "should fail when lint" do
        	@flutter_lint.lint

        	expect(@flutter_lint.status_report[:errors]).to eq(["Could not find `flutter` inside current directory"])
      	end
    	end

    	context "when flutter is installed" do
    		before do
    			allow(@flutter_lint).to receive(:`).with("which flutter").and_return("/Users/johndoe/.flutter/bin/flutter")
    		end

    		context "when `flutter analyze` returns no violations" do
    			before do
    				stubbed_output = """
    				Analyzing my_flutter_project...

    					No issues found!
   					"""
    				allow(@flutter_lint).to receive(:`).with("flutter analyze").and_return(stubbed_output)
    			end

    			it "should NOT fail when lint" do
        		@flutter_lint.lint

        		expect(@flutter_lint.status_report[:errors]).to be_empty
      		end

		    	it "should add markdown message with 0 violations when inline mode is off" do
		      	@flutter_lint.lint(inline_mode: false)

		      	markdown = @flutter_lint.status_report[:markdowns].first.message
          	expect(markdown).to eq("### FlutterLint found 0 issues ✅")
          end

          it "should NOT print markdown message when inline mode is on" do
		      	@flutter_lint.lint(inline_mode: true)

		      	markdown = @flutter_lint.status_report[:markdowns]
          	expect(markdown).to be_empty
          end
    		end

    		context "when `flutter analyze` returns some violations" do
    			before do
    				stubbed_output = """
	        	Analyzing my_flutter_project...

	   						info • Name types using UpperCamelCase • lib/main.dart:5:7 • camel_case_types
	   						info • Prefer const with constant constructors • lib/home/home_page.dart:13:13 • prefer_const_constructors
	   						info • AVOID catches without on clauses • lib/profile/user/phone_widget.dart:19:7 • avoid_catches_without_on_clauses
	   				"""
	   				allow(@flutter_lint).to receive(:`).with("flutter analyze").and_return(stubbed_output)
    			end

    			it "should NOT fail when lint" do
        		@flutter_lint.lint

        		expect(@flutter_lint.status_report[:errors]).to be_empty
      		end

      		it "should print markdown message with 2 violations when inline mode is off" do
		      	@flutter_lint.lint(inline_mode: false)

		      	expected = <<~MESSAGE
		      	### FlutterLint found 2 issues ❌\n
		      	| File | Line | Rule |
		      	| ---- | ---- | ---- |
		      	| `lib/home/home_page.dart` | 13 | prefer_const_constructors |
		      	| `lib/profile/user/phone_widget.dart` | 19 | avoid_catches_without_on_clauses |
		      	MESSAGE

          	expect(@flutter_lint.status_report[:markdowns].first.message).to eq(expected)
          end

          it "should send inline comment instead of markdown when inline mode is on" do
		      	@flutter_lint.lint(inline_mode: true)

		      	warnings = @flutter_lint.status_report[:warnings]

		      	expect(warnings).to eq(["Prefer const with constant constructors", "AVOID catches without on clauses"])
          end
    		end
    	end
    end
  end
end
