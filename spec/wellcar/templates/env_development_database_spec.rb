require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "wellcar/templates/env_development_database"

RSpec.describe Wellcar::Templates::EnvDevelopmentDatabase do
  describe "#render" do
    subject { template.render }
    
    let(:password) { class_double "SecureRandom" }

    before do
      stub_const "SecureRandom", password
      expect(password).to receive(:base64).with(20).and_return "a-password"
    end

    context "with a first set of inputs" do
      let(:template) { described_class.new("test_app") }

      it { is_expected.to include("POSTGRES_DB=test_app_development") }
      it { is_expected.to include("POSTGRES_USER=postgres") }
      it { is_expected.to include("POSTGRES_PASSWORD=a-password") }
    end

    context "with another set of inputs" do
      let(:template) { described_class.new("old_app") }

      it { is_expected.to include("POSTGRES_DB=old_app_development") }
      it { is_expected.to include("POSTGRES_USER=postgres") }
      it { is_expected.to include("POSTGRES_PASSWORD=a-password") }
    end
  end
end
