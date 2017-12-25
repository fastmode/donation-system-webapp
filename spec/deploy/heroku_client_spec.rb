# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/heroku_client'

RSpec.describe Deploy::HerokuClient do
  let(:config) do
    {
      api_key: 'api_key',
      app_name: 'app-name',
      env_vars: { 'FOO' => 'bar' },
      git_upstream_name: 'staging',
      git_local_branch: 'HEAD'
    }
  end

  let(:heroku) { described_class.new(config) }
  let(:client) { instance_double(PlatformAPI::Client) }

  before do
    allow(PlatformAPI).to receive(:connect).and_return(client)
    allow(client).to receive_message_chain(:oauth_authorization, :list)
    allow(client).to receive_message_chain(:app, :info)
    allow(client).to receive_message_chain(:config_var, :update)
    allow(Kernel).to receive(:system).and_return(true)
  end

  describe('when successful') do
    it 'passes the API key to the Heroku client' do
      expect(PlatformAPI).to receive(:connect).with('api_key')
      heroku.deploy
    end

    it 'updates the environment variables upstream' do
      expect(client).to receive_message_chain(:config_var, :update)
        .with('app-name', 'FOO' => 'bar')
      heroku.deploy
    end

    it 'pushes the app to Heroku' do
      expect(Kernel).to receive(:system).with(/git push/)
      heroku.deploy
    end

    it 'uses heroku upstream name when pushing the app' do
      expect(Kernel).to receive(:system).with(/staging/)
      heroku.deploy
    end

    it 'uses local commit name when pushing the app' do
      expect(Kernel).to receive(:system).with(/HEAD/)
      heroku.deploy
    end
  end

  describe('when unsuccessful') do
    it 'has errors if credentials are missing' do
      allow(client).to receive_message_chain(:oauth_authorization, :list)
        .and_raise(Excon::Error::Unauthorized.new(''))
      message = described_class::ERROR_MESSAGES[:missing_credentials]
      expect(heroku.deploy).to include(/#{message}/)
    end

    it 'has errors if environment variables are not in the right format' do
      heroku = described_class.new(config.merge(env_vars: 'malformed'))
      message = described_class::ERROR_MESSAGES[:malformed_env_vars]
      expect(heroku.deploy).to include(/#{message}/)
    end

    it 'has errors if application name is taken by other user' do
      allow(client).to receive_message_chain(:app, :info)
        .and_raise(Excon::Error::Forbidden.new(''))
      message = described_class::ERROR_MESSAGES[:invalid_app_name]
      expect(heroku.deploy).to include(/#{message}/)
    end

    it 'has errors if application name does not exist' do
      allow(client).to receive_message_chain(:app, :info)
        .and_raise(Excon::Error::NotFound.new(''))
      message = described_class::ERROR_MESSAGES[:invalid_app_name]
      expect(heroku.deploy).to include(/#{message}/)
    end

    it 'does not update the environment variables upstream if malformed' do
      heroku = described_class.new(config.merge(env_vars: 'malformed'))
      expect(client).not_to receive(:config_var)
      heroku.deploy
    end

    it 'has errors if there were problems with git' do
      allow(Kernel).to receive(:system).and_return(false)
      message = described_class::ERROR_MESSAGES[:problems_pushing]
      expect(heroku.deploy).to include(/#{message}/)
    end
  end
end
