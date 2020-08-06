require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "wellcar/templates/env_production_database"

RSpec.describe Wellcar::Templates::EnvProductionDatabase do
  describe "#render" do
    subject { template.render }

    let(:password) { class_double "SecureRandom" }

    before do
      stub_const "SecureRandom", password
      expect(password).to receive(:base64).with(20).and_return "prod-password"
    end

    context "with a first set of inputs" do
      let(:template) { described_class.new("test_app") }

      it { is_expected.to include("POSTGRES_DB=test_app_production") }
      it { is_expected.to include("POSTGRES_USER=postgres") }
      it { is_expected.to include("POSTGRES_PASSWORD=prod-password") }
    end

    context "with another set of inputs" do
      let(:template) { described_class.new("old_app") }

      it { is_expected.to include("POSTGRES_DB=old_app_production") }
      it { is_expected.to include("POSTGRES_USER=postgres") }
      it { is_expected.to include("POSTGRES_PASSWORD=prod-password") }
    end
  end
end
