require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/build_production_image"

RSpec.describe Wellcar::Templates::BuildProductionImage do
  describe "#write" do
    context "with an app name and GitHub account when directory does not exist" do
      let(:template) { described_class.new "test_app", "github_user" }

      around do |spec|
        Dir.chdir File.join(File.dirname(__FILE__), "..", "..", "..", "tmp") do
          FileUtils.rm_rf ".github" if Dir.exist? ".github"
          spec.run
          FileUtils.rm_rf ".github" if Dir.exist? ".github"
        end
      end

      it do
        template.write

        expect(Dir[".github/workflows/*"]).to match_array ".github/workflows/build-production-image.yml"

        contents = YAML::load File.read(".github/workflows/build-production-image.yml")
        expect(contents.dig("jobs", "push_to_registry", "steps")[1].dig("with", "repository")).to eq "github_user/test_app/nginx"
        expect(contents.dig("jobs", "push_to_registry", "steps")[1].dig("with", "target")).to eq "reverse_proxy"
        expect(contents.dig("jobs", "push_to_registry", "steps")[2].dig("with", "repository")).to eq "github_user/test_app/web"
        expect(contents.dig("jobs", "push_to_registry", "steps")[2].dig("with", "target")).to eq "production"
      end
    end

    context "with an app name and GitHub account when directory exists" do
      let(:template) { described_class.new "test_app", "github_user" }

      around do |spec|
        Dir.chdir File.join(File.dirname(__FILE__), "..", "..", "..", "tmp") do
          FileUtils.mkdir_p ".github/workflows"
          spec.run
          FileUtils.rm_rf ".github" if Dir.exist? ".github"
        end
      end

      it do
        template.write

        expect(Dir[".github/workflows/*"]).to match_array ".github/workflows/build-production-image.yml"

        contents = YAML::load File.read(".github/workflows/build-production-image.yml")
        expect(contents.dig("jobs", "push_to_registry", "steps")[1].dig("with", "repository")).to eq "github_user/test_app/nginx"
        expect(contents.dig("jobs", "push_to_registry", "steps")[1].dig("with", "target")).to eq "reverse_proxy"
        expect(contents.dig("jobs", "push_to_registry", "steps")[2].dig("with", "repository")).to eq "github_user/test_app/web"
        expect(contents.dig("jobs", "push_to_registry", "steps")[2].dig("with", "target")).to eq "production"
      end
    end
  end
end
