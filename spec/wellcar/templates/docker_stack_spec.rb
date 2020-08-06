require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/docker_stack"

RSpec.describe Wellcar::Templates::DockerStack do
  describe "#render" do
    subject { YAML::load(template.render) }

    context "with an app and a GitHub account" do
      let(:template) { described_class.new("test_app", "github_user") }

      it { expect(subject.dig("services", "reverseproxy", "ports")).to include "127.0.0.1:3001:3001" }
      it { expect(subject.dig("services", "reverseproxy", "image")).to eq "docker.pkg.github.com/github_user/test_app/nginx" }
      it { expect(subject.dig("services", "web", "image")).to eq("docker.pkg.github.com/github_user/test_app/web") }
      it { expect(subject.dig("services", "web", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "web", "env_file")).to include ".env/production/web" }
      it { expect(subject.dig("services", "database", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "db-migrator", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "db-migrator", "env_file")).to include ".env/production/web" }
      it { expect(subject.dig("services", "db-migrator", "image")).to eq("docker.pkg.github.com/github_user/test_app/web") }
    end

    context "with another app and a different GitHub account" do
      let(:template) { described_class.new("funky_app", "github_person") }

      it { expect(subject.dig("services", "reverseproxy", "ports")).to include "127.0.0.1:3001:3001" }
      it { expect(subject.dig("services", "reverseproxy", "image")).to eq "docker.pkg.github.com/github_person/funky_app/nginx" }
      it { expect(subject.dig("services", "web", "image")).to eq("docker.pkg.github.com/github_person/funky_app/web") }
      it { expect(subject.dig("services", "web", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "web", "env_file")).to include ".env/production/web" }
      it { expect(subject.dig("services", "database", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "db-migrator", "env_file")).to include ".env/production/database" }
      it { expect(subject.dig("services", "db-migrator", "env_file")).to include ".env/production/web" }
      it { expect(subject.dig("services", "db-migrator", "image")).to eq("docker.pkg.github.com/github_person/funky_app/web") }
    end
  end
end
