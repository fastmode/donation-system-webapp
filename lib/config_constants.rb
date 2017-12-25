# frozen_string_literal: true

module ConfigConstants
  DEVELOPMENT = 'development'
  STAGING = 'staging'
  PRODUCTION = 'production'

  AWS_S3_RESOURCE_OPTIONS = {
    region: 'us-east-1',
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }.freeze

  LOCAL_PUBLIC_DIRECTORY = 'public'
  PATH_TO_MAIN_CSS = 'css/main.css'
  PATH_TO_MAIN_JS = 'js/bundle.js'

  UPSTREAM_CSS_ENVVARNAME = 'MAIN_CSS_UPSTREAM_FILEPATH'
  UPSTREAM_JS_ENVVARNAME = 'BUNDLE_JS_UPSTREAM_FILEPATH'

  STAGING_BUCKET_NAME = 'assets-development.survivalinternational.org'
  PRODUCTION_BUCKET_NAME = 'assets-production.survivalinternational.org'
  BUCKET_PATH = 'donation-system-webapp'

  STAGING_URL = "https://#{STAGING_BUCKET_NAME}/#{BUCKET_PATH}"
  PRODUCTION_URL = "https://#{PRODUCTION_BUCKET_NAME}/#{BUCKET_PATH}"

  STAGING_ARGS = {
    bucket_name: STAGING_BUCKET_NAME,
    heroku_setup: {
      heroku_app_name: 'donation-system-staging',
      git_upstream_name: STAGING,
      git_local_branch: 'HEAD'
    }
  }.freeze

  PRODUCTION_ARGS = {
    bucket_name: PRODUCTION_BUCKET_NAME,
    heroku_setup: {
      heroku_app_name: 'donation-system-production',
      git_upstream_name: PRODUCTION,
      git_local_branch: 'master'
    }
  }.freeze

  CSS_ARGS = {
    filepath: PATH_TO_MAIN_CSS,
    heroku_setup: { asset_path_envname: UPSTREAM_CSS_ENVVARNAME }
  }.freeze

  JS_ARGS = {
    filepath: PATH_TO_MAIN_JS,
    heroku_setup: { asset_path_envname: UPSTREAM_JS_ENVVARNAME }
  }.freeze

  def self.merge_recursively(old_h, novel_h)
    old_h.merge(novel_h) do |key, old, novel|
      if old.is_a? Hash
        merge_recursively(old, novel)
      else
        old_h[key] = novel
      end
    end
  end
end
