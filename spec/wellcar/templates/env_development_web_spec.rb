require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/env_development_web"

RSpec.describe Wellcar::Templates::EnvDevelopmentWeb do
  describe "#render" do
    subject { template.render }

    let(:template) { described_class.new }

    it { is_expected.to include("DATABASE_HOST=database") }
  end
end
