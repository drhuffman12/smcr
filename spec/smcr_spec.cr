require "./spec_helper"

Spectator.describe Smcr do
  describe "Smcr::VERSION" do
    it "is defined" do
      expect(Smcr::VERSION).to be_a(String)
    end
  end
end
