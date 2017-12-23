# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/amazon_file_uploader'

RSpec.describe Deploy::AmazonFileUploader do
  let(:bucket) { Aws::S3::Resource.new(stub_responses: true).bucket('bucket') }
  let(:args) do
    {
      options: { stub_responses: true },
      bucket_name: 'bucket',
      local_filepath: local_filepath,
      upstream_filepath: 'upstream/css/main-123.css'
    }
  end
  let(:uploader) { described_class.new(args) }

  before do
    allow_any_instance_of(Aws::S3::Resource).to receive(:bucket)
      .and_return(bucket)
  end

  describe 'when it succeeds' do
    it 'returns no errors' do
      expect(uploader.upload).to be_empty
    end

    it 'uploads the file to the bucket object' do
      expect(bucket).to receive_message_chain(:object, :upload_file)
      uploader.upload
    end

    it 'passes the upstream filepath to the bucket object' do
      allow(bucket).to receive_message_chain(:object, :upload_file)

      expect(bucket).to receive(:object).with('upstream/css/main-123.css')
      uploader.upload
    end

    it 'passes the local filepath to the bucket object' do
      expect(bucket).to receive_message_chain(:object, :upload_file)
        .with(args[:local_filepath])
      uploader.upload
    end
  end

  describe 'when credentials are missing' do
    before do
      allow(Aws::S3::Resource)
        .to receive(:new)
        .and_raise(Aws::Sigv4::Errors::MissingCredentialsError)
    end

    it 'has errors' do
      message = described_class::ERROR_MESSAGES[:missing_s3_credentials]
      expect(uploader.upload).to include(/#{message}/)
    end

    it 'does not create bucket' do
      message = described_class::ERROR_MESSAGES[:missing_bucket]
      expect(uploader.upload).to include(/#{message}/)
    end

    it 'does not upload the file' do
      expect(bucket).not_to receive(:object)
      uploader.upload
    end
  end

  describe 'when bucket does not exist' do
    before do
      allow(bucket).to receive(:exists?).and_return(false)
    end

    it 'has errors' do
      message = described_class::ERROR_MESSAGES[:missing_bucket]
      expect(uploader.upload).to include(/#{message}/)
    end

    it 'does not upload the file' do
      expect(bucket).not_to receive(:object)
      uploader.upload
    end
  end

  describe 'when local file does not exist' do
    it 'has errors' do
      uploader = described_class.new(args.merge(local_filepath: 'i-dont-exist'))
      message = described_class::ERROR_MESSAGES[:missing_local_file]
      expect(uploader.upload).to include(/#{message}/)
    end
  end

  describe 'when problems with uploading' do
    it 'has errors' do
      allow(bucket).to receive_message_chain(:object, :upload_file)
        .and_raise(Aws::S3::MultipartUploadError.new('', ''))
      message = described_class::ERROR_MESSAGES[:multipart_upload_error]
      expect(uploader.upload).to include(/#{message}/)
    end
  end

  def local_filepath
    @local_filepath ||= Tempfile.new.path
  end
end
