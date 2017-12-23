# frozen_string_literal: true

module ErrorMessages
  FILE_HELPER_ERRORS = {
    timestamping_error: 'Timestamping file failed for',
    deleting_error: 'Deleting file failed for'
  }.freeze

  AMAZON_FILE_UPLOADER_ERRORS = {
    missing_s3_credentials: 'Missing AWS S3 credentials, bucket not created',
    missing_bucket: 'Missing AWS S3 bucket or it was not created',
    missing_local_file: 'Missing local file',
    multipart_upload_error: 'Multipart AWS S3 upload error'
  }.freeze

  ERROR_MESSAGES = FILE_HELPER_ERRORS
                   .merge(AMAZON_FILE_UPLOADER_ERRORS)

  def join(*args)
    args.join(' ')
  end
end
