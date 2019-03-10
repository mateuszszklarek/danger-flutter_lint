require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerFlutterLint do
    it "should be a danger plugin" do
      expect(Danger::DangerFlutterLint.new(nil)).to be_a Danger::Plugin
    end
  end
end
