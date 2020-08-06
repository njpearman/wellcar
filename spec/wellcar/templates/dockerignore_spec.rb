require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/dockerignore"

RSpec.describe Wellcar::Templates::Dockerignore do
  describe "#render" do
    subject { template.render }

    let(:template) { described_class.new }

    let(:ignores) do
      <<IGNORES
Dockerfile
docker-compose.yml
.env
*.swp
*.swo
.git
.gitignore
.wellcar/*
logs/*
tmp/*
IGNORES
    end

    it { is_expected.to match ignores }
  end
end
