require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/env_production_web"

RSpec.describe Wellcar::Templates::EnvProductionWeb do
  describe "#render" do
    subject { template.render }

    context "with a key" do
      let(:template) { described_class.new("thekey") }

      it { is_expected.to include("RAILS_MASTER_KEY=thekey") }
      it { is_expected.to include("DATABASE_HOST=database") }
      it { is_expected.to include("RAILS_ENV=production") }
      it { is_expected.to include("RAILS_LOG_TO_STDOUT=true") }
      it { is_expected.to include("RAILS_SERVE_STATIC_FILES=true") }
    end

    context "with another key" do
      let(:template) { described_class.new("anotherkey") }

      it { is_expected.to include("RAILS_MASTER_KEY=anotherkey") }
      it { is_expected.to include("DATABASE_HOST=database") }
      it { is_expected.to include("RAILS_ENV=production") }
      it { is_expected.to include("RAILS_LOG_TO_STDOUT=true") }
      it { is_expected.to include("RAILS_SERVE_STATIC_FILES=true") }
    end
  end
end
