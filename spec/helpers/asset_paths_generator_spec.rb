# frozen_string_literal: true

require 'spec_helper'
require 'support/with_env'

require_relative '../../lib/helpers/asset_paths_generator'

RSpec.describe Helpers::AssetPathsGenerator do
  include Support::WithEnv

  it 'builds the development path to the local main CSS file' do
    generator = described_class.new(described_class::DEVELOPMENT)
    expect(generator.main_css_path).to eq('css/main.css')
  end

  it 'builds the staging path with the main CSS upstream-only env' do
    with_env(described_class::UPSTREAM_CSS_ENVVARNAME => 'css/main-123.css') do
      generator = described_class.new(described_class::STAGING)
      expect(generator.main_css_path)
        .to eq("#{described_class::STAGING_URL}/css/main-123.css")
    end
  end

  it 'builds the production path with the main CSS upstream-only env' do
    with_env(described_class::UPSTREAM_CSS_ENVVARNAME => 'css/main-456.css') do
      generator = described_class.new(described_class::PRODUCTION)
      expect(generator.main_css_path)
        .to eq("#{described_class::PRODUCTION_URL}/css/main-456.css")
    end
  end

  it 'returns path to local file if upstream-only env var not set' do
    generator = described_class.new('test')
    expect(generator.main_css_path).to eq('css/main.css')
  end

  it 'builds the development path to the bundle JS file' do
    generator = described_class.new(described_class::DEVELOPMENT)
    expect(generator.main_js_path).to eq('js/bundle.js')
  end

  it 'builds the staging path with the main JS upstream-only env' do
    with_env(described_class::UPSTREAM_JS_ENVVARNAME => 'js/bundler-456.js') do
      generator = described_class.new(described_class::STAGING)
      expect(generator.main_js_path)
        .to eq("#{described_class::STAGING_URL}/js/bundler-456.js")
    end
  end

  it 'builds the production path with the main JS upstream-only env' do
    with_env(described_class::UPSTREAM_JS_ENVVARNAME => 'js/bundler-123.js') do
      generator = described_class.new(described_class::PRODUCTION)
      expect(generator.main_js_path)
        .to eq("#{described_class::PRODUCTION_URL}/js/bundler-123.js")
    end
  end

  it 'returns path to local file if upstream-only env var not set' do
    generator = described_class.new('test')
    expect(generator.main_js_path).to eq('js/bundle.js')
  end
end
