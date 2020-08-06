require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "yaml"
require "wellcar/templates/docker_entrypoint"

RSpec.describe Wellcar::Templates::DockerEntrypoint do
  describe "#render" do
    subject { template.render }

    let(:template) { described_class.new }

    let(:pid_script) do
      <<SCRIPT
if [ -f tmp/pids/server.pid ]; then
  echo "Removing server.pid file"
  rm tmp/pids/server.pid
fi
SCRIPT
    end

    let(:launch_script) do
      <<SCRIPT
bundle install
yarn install --check-files

exec "$@"
SCRIPT
    end

    it { is_expected.to include pid_script }
    it { is_expected.to include launch_script }
  end
end
