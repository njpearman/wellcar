require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")
require "wellcar/templates/dockerfile"

RSpec.describe Wellcar::Templates::Dockerfile do
  describe "#render" do
    subject { template.render }

    context "with a first set of inputs" do
      let(:template) { described_class.new("2.6.6", "test_app") }

      it { is_expected.to include "FROM nginx:alpine AS reverse_proxy" }
      it { is_expected.to include "COPY config/nginx/reverse-proxy.conf /etc/nginx/conf.d/reverse-proxy.conf" }
      it { is_expected.to include "FROM ruby:2.6.6 AS core_dependencies" }
      it { is_expected.to include "WORKDIR /app/test_app" }
      it { is_expected.to include "COPY Gemfile* yarn.lock package.json /app/test_app/" }
      it { is_expected.to include "COPY . /app/test_app/" }
      it { is_expected.to_not include "RUN gem install bundler" }
    end

    context "with another set of inputs" do
      let(:template) { described_class.new("1.0.0", "old_app") }

      it { is_expected.to include "FROM nginx:alpine AS reverse_proxy" }
      it { is_expected.to include "COPY config/nginx/reverse-proxy.conf /etc/nginx/conf.d/reverse-proxy.conf" }
      it { is_expected.to include "FROM ruby:1.0.0 AS core_dependencies" }
      it { is_expected.to include "WORKDIR /app/old_app" }
      it { is_expected.to include "COPY Gemfile* yarn.lock package.json /app/old_app/" }
      it { is_expected.to include "COPY . /app/old_app/" }
      it { is_expected.to_not include "RUN gem install bundler" }
    end

    context "using bundler" do
      let(:template) { described_class.new("2.6.6", "modern_app", true) }

      it { is_expected.to include "FROM nginx:alpine AS reverse_proxy" }
      it { is_expected.to include "COPY config/nginx/reverse-proxy.conf /etc/nginx/conf.d/reverse-proxy.conf" }
      it { is_expected.to include "FROM ruby:2.6.6 AS core_dependencies" }
      it { is_expected.to include "WORKDIR /app/modern_app" }
      it { is_expected.to include "COPY Gemfile* yarn.lock package.json /app/modern_app/" }
      it { is_expected.to include "COPY . /app/modern_app/" }
      it { is_expected.to include "RUN gem install bundler" }
    end
  end
end
