require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "wellcar/templates/reverse_proxy_conf"

RSpec.describe Wellcar::Templates::ReverseProxyConf do
  describe "#render" do
    subject { template.render }

    context "with a first set of inputs" do
      let(:template) { described_class.new("www.shinyshiny.com") }

      it { is_expected.to include "server_name www.shinyshiny.com localhost" }
      it { is_expected.to include "allow 172.0.0.0/8;" }
      it { is_expected.to include "deny all;" }
    end
  end
end
