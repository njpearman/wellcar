require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "wellcar/templates/dockerfile_init"

RSpec.describe Wellcar::Templates::DockerfileInit do
  describe "#render" do
    subject { template.render }

    context "with a first set of inputs" do
      let(:template) { Wellcar::Templates::DockerfileInit.new("2.6.6", "test_app") }

      it { is_expected.to include "FROM ruby:2.6.6 AS base_for_new" }
      it { is_expected.to include "WORKDIR /app/test_app" }
      it { is_expected.to include 'CMD ["rails", "new", "--database", "postgresql", "--skip-bundle", "--skip-webpack-install", "--skip-test", "."]' }
      it { is_expected.to include "COPY --from=new_rails /app/test_app/ ." }
      it { is_expected.to include "COPY --from=bundle_for_lockfile /app/test_app/ ." }
    end

    context "with another set of inputs" do
      let(:template) { Wellcar::Templates::DockerfileInit.new("1.0.0", "old_app") }

      it { is_expected.to include "ruby:1.0.0" }
      it { is_expected.to include "WORKDIR /app/old_app" }
      it { is_expected.to include 'CMD ["rails", "new", "--database", "postgresql", "--skip-bundle", "--skip-webpack-install", "--skip-test", "."]' }
      it { is_expected.to include "COPY --from=new_rails /app/old_app/ ." }
      it { is_expected.to include "COPY --from=bundle_for_lockfile /app/old_app/ ." }
    end
  end
end
