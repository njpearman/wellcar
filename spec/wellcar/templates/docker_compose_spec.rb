require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/docker_compose"

RSpec.describe Wellcar::Templates::DockerCompose do
  describe "#render" do
    subject { YAML::load(template.render) }

    context "with a first set of inputs" do
      let(:template) { described_class.new("test_app", "github_user") }

      it { expect(subject.dig("services", "reverseproxy", "ports")).to include "127.0.0.1:3001:3001" }
      it { expect(subject.dig("services", "production", "image")).to eq "docker.pkg.github.com/github_user/test_app/web" }
      it { expect(subject.dig("services", "webpack-dev-server", "volumes")).to include(".:/app/test_app", "node_modules:/app/test_app/node_modules") }
      it { expect(subject["services"]["web"]["volumes"]).to include(".:/app/test_app", "node_modules:/app/test_app/node_modules") }
    end

    context "with another set of inputs" do
      let(:template) { described_class.new("old_app", "github_user") }

      it { expect(subject.dig("services", "webpack-dev-server", "volumes")).to include(".:/app/old_app", "node_modules:/app/old_app/node_modules") }
      it { expect(subject.dig("services", "web", "volumes")).to include(".:/app/old_app", "node_modules:/app/old_app/node_modules") }
    end

    context "with an explicit template name" do
      let(:template) { described_class.new("init_app", "github_user", described_class::INIT_TEMPLATE) }

      it { expect(subject.dig("services", "new_rails", "volumes")).to include(".:/app/init_app") }
      it { expect(subject.dig("services", "bundle", "volumes")).to include(".:/app/init_app") }
      it { expect(subject.dig("services", "install_webpacker", "volumes")).to include(".:/app/init_app", "node_modules:/app/init_app/node_modules") }
    end
  end
end

