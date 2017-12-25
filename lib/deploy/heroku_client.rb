# frozen_string_literal: true

require 'platform-api'

require_relative '../error_messages'

module Deploy
  class HerokuClient
    include ErrorMessages

    def initialize(api_key:, app_name:, env_vars:,
                   git_upstream_name:, git_local_branch:)
      @api_key = api_key
      @app_name = app_name
      @env_vars = env_vars
      @git_upstream_name = git_upstream_name
      @git_local_branch = git_local_branch
      @errors = []
    end

    def deploy
      validate_inputs
      update_upstream_environment if errors.empty?
      push_to_upstream
      errors
    end

    private

    attr_reader :api_key, :app_name, :env_vars,
                :git_upstream_name, :git_local_branch, :errors

    def validate_inputs
      validate_api_key
      validate_app_name
      validate_env_vars
    end

    def validate_api_key
      client.oauth_authorization.list
    rescue Excon::Error::Unauthorized
      errors << join(ERROR_MESSAGES[:missing_credentials], client)
      []
    end

    def validate_app_name
      client.app.info(app_name)
    rescue Excon::Error::Forbidden, Excon::Error::NotFound
      errors << join(ERROR_MESSAGES[:invalid_app_name], client)
      {}
    end

    def validate_env_vars
      message = join(ERROR_MESSAGES[:malformed_env_vars], env_vars)
      errors << message unless env_vars.is_a? Hash
    end

    def update_upstream_environment
      client.config_var.update(app_name, env_vars)
    end

    def push_to_upstream
      okay = Kernel.system("git push #{git_upstream_name} #{git_local_branch}")
      message = join(
        ERROR_MESSAGES[:problems_pushing], git_upstream_name, git_local_branch
      )
      errors << message unless okay
    end

    def client
      @client ||= PlatformAPI.connect(api_key)
    end
  end
end
