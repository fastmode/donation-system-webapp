# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/deployer'

module Deploy
  RSpec.describe Deployer do
    let(:deployer) do
      described_class.new(
        filepath: 'css/main.css',
        bucket_name: 'assets-production.com',
        heroku_setup: {
          heroku_app_name: 'production-app-name',
          asset_path_envname: 'CSS_VAR_NAME',
          git_upstream_name: 'production',
          git_local_branch: 'master'
        }
      )
    end

    before do
      allow_any_instance_of(FileHelper).to receive(:append_timestamp)
        .and_return([])
      allow_any_instance_of(AmazonFileUploader).to receive(:upload)
        .and_return([])
      allow_any_instance_of(HerokuClient).to receive(:deploy).and_return([])
      allow_any_instance_of(FileHelper).to receive(:undo_append_timestamp)
        .and_return([])
      allow_any_instance_of(ErrorPrinter).to receive(:dump).and_return(nil)
    end

    describe('when successful') do
      it 'works' do
        expect(deployer.run).to be_empty
      end

      it 'appends timestamp to file path' do
        expect_any_instance_of(FileHelper).to receive(:append_timestamp)
        deployer.run
      end

      it 'uploads timestamped file to Amazon' do
        expect_any_instance_of(AmazonFileUploader).to receive(:upload)
        deployer.run
      end

      it 'deploys to Heroku' do
        expect_any_instance_of(HerokuClient).to receive(:deploy)
        deployer.run
      end

      it 'undoes timestamping' do
        expect_any_instance_of(FileHelper).to receive(:undo_append_timestamp)
        deployer.run
      end

      it 'prints errors' do
        expect_any_instance_of(ErrorPrinter).to receive(:dump)
        deployer.run
      end
    end

    describe('when timestamping fails') do
      before do
        allow_any_instance_of(FileHelper).to receive(:append_timestamp)
          .and_return(['error'])
      end

      it 'has errors' do
        expect(deployer.run).to include('error')
      end

      it 'does not upload assets' do
        expect_any_instance_of(AmazonFileUploader).not_to receive(:upload)
        deployer.run
      end

      it 'does not deploy to Heroku' do
        expect_any_instance_of(HerokuClient).not_to receive(:deploy)
        deployer.run
      end
    end

    describe('when uploading fails') do
      it 'has errors' do
        allow_any_instance_of(AmazonFileUploader).to receive(:upload)
          .and_return(['error'])
        expect(deployer.run).to include('error')
      end
    end

    describe('when deploying to Heroku fails') do
      it 'has errors' do
        allow_any_instance_of(HerokuClient).to receive(:deploy)
          .and_return(['error'])
        expect(deployer.run).to include('error')
      end
    end

    describe('when removing timestamped file fails') do
      it 'has errors' do
        allow_any_instance_of(FileHelper).to receive(:undo_append_timestamp)
          .and_return(['error'])
        expect(deployer.run).to include('error')
      end
    end

    describe('#self.staging') do
      it 'runs the deployer for each file' do
        expect(described_class).to receive(:new).twice.and_call_original
        described_class.staging
      end
    end

    describe('#self.production') do
      it 'runs the deployer for each file' do
        expect(described_class).to receive(:new).twice.and_call_original
        described_class.production
      end
    end
  end
end
