# frozen_string_literal: true

require_relative '../config_constants'

module Helpers
  class AssetPathsGenerator
    include ConfigConstants

    def initialize(environment)
      @environment = environment
    end

    def main_css_path
      {
        DEVELOPMENT => PATH_TO_MAIN_CSS,
        STAGING => staging_css_path,
        PRODUCTION => production_css_path
      }.fetch(environment, PATH_TO_MAIN_CSS)
    end

    def main_js_path
      {
        DEVELOPMENT => PATH_TO_MAIN_JS,
        STAGING => staging_js_path,
        PRODUCTION => production_js_path
      }.fetch(environment, PATH_TO_MAIN_JS)
    end

    private

    attr_reader :environment

    def staging_css_path
      "#{STAGING_URL}/#{ENV[UPSTREAM_CSS_ENVVARNAME]}"
    end

    def production_css_path
      "#{PRODUCTION_URL}/#{ENV[UPSTREAM_CSS_ENVVARNAME]}"
    end

    def staging_js_path
      "#{STAGING_URL}/#{ENV[UPSTREAM_JS_ENVVARNAME]}"
    end

    def production_js_path
      "#{PRODUCTION_URL}/#{ENV[UPSTREAM_JS_ENVVARNAME]}"
    end
  end
end
