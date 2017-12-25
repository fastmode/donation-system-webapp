# frozen_string_literal: true

require_relative '../config_constants'

require_relative 'amazon_file_uploader'
require_relative 'error_printer'
require_relative 'file_helper'
require_relative 'heroku_client'

module Deploy
  class Deployer
    include ConfigConstants

    def self.staging
      new(ConfigConstants.merge_recursively(STAGING_ARGS.dup, CSS_ARGS)).run
      new(ConfigConstants.merge_recursively(STAGING_ARGS.dup, JS_ARGS)).run
    end

    def self.production
      new(ConfigConstants.merge_recursively(PRODUCTION_ARGS.dup, CSS_ARGS)).run
      new(ConfigConstants.merge_recursively(PRODUCTION_ARGS.dup, JS_ARGS)).run
    end

    def initialize(filepath:, bucket_name:, heroku_setup:)
      @filepath = filepath
      @bucket_name = bucket_name
      @heroku_setup = heroku_setup
      @errors = []
    end

    def run
      append_timestamp
      upload_assets if errors.empty?
      deploy_app if errors.empty?
      undo_append_timestamp
      print_errors
      errors
    end

    private

    attr_reader :filepath, :bucket_name, :heroku_setup, :errors

    def append_timestamp
      errors << file_helper.append_timestamp
      errors.flatten!
    end

    def upload_assets
      errors << amazon_file_uploader.upload
      errors.flatten!
    end

    def deploy_app
      errors << heroku_client.deploy
      errors.flatten!
    end

    def undo_append_timestamp
      errors << file_helper.undo_append_timestamp
      errors.flatten!
    end

    def print_errors
      error_printer.dump
    end

    def file_helper
      @file_helper ||= FileHelper.new(
        filepath: filepath,
        local_directory: LOCAL_PUBLIC_DIRECTORY,
        upstream_directory: BUCKET_PATH
      )
    end

    def amazon_file_uploader
      AmazonFileUploader.new(
        options: AWS_S3_RESOURCE_OPTIONS,
        bucket_name: bucket_name,
        local_filepath: file_helper.local_timestamped_filepath,
        upstream_filepath: file_helper.upstream_timestamped_filepath
      )
    end

    def heroku_client
      HerokuClient.new(
        api_key: ENV['HEROKU_API_KEY'],
        app_name: heroku_setup[:heroku_app_name],
        env_vars: env_var,
        git_upstream_name: heroku_setup[:git_upstream_name],
        git_local_branch: heroku_setup[:git_local_branch]
      )
    end

    def env_var
      {
        heroku_setup[:asset_path_envname] =>
          file_helper.upstream_timestamped_filepath
      }
    end

    def error_printer
      ErrorPrinter.new(errors)
    end
  end
end
