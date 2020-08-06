require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/database_yaml"

RSpec.describe Wellcar::Templates::DatabaseYaml do
  describe "#render" do
    subject { YAML::load(template.render) }

    context "with a first set of inputs" do
      let(:template) { Wellcar::Templates::DatabaseYaml.new("test_app") }

      it { expect(subject["development"]["host"]).to eq("<%= ENV.fetch(\"DATABASE_HOST\") %>") }
      it { expect(subject["development"]["username"]).to eq("<%= ENV.fetch(\"POSTGRES_USER\") %>") }
      it { expect(subject["development"]["password"]).to eq("<%= ENV.fetch(\"POSTGRES_PASSWORD\") %>") }
      it { expect(subject["development"]["database"]).to eq("<%= ENV.fetch(\"POSTGRES_DB\") %>") }
      it { expect(subject["test"]["database"]).to eq("test_app") }
    end

    context "with another set of inputs" do
      let(:template) { Wellcar::Templates::DatabaseYaml.new("old_app") }

      it { expect(subject["test"]["database"]).to eq("old_app") }
    end
  end
end


