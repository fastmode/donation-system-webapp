# frozen_string_literal: true

require 'date'

require_relative '../error_messages'

module Deploy
  class FileHelper
    include ErrorMessages

    def initialize(filepath:, local_directory:, upstream_directory:)
      @filepath = filepath
      @local_directory = local_directory
      @upstream_directory = upstream_directory
      @errors = errors
    end

    def append_timestamp
      FileUtils.cp(local_filepath, local_timestamped_filepath)
      []
    rescue Errno::ENOENT
      [join(ERROR_MESSAGES[:timestamping_error], local_timestamped_filepath)]
    end

    def undo_append_timestamp
      File.delete(local_timestamped_filepath)
      []
    rescue Errno::ENOENT
      [join(ERROR_MESSAGES[:deleting_error], local_timestamped_filepath)]
    end

    def local_timestamped_filepath
      File.join(local_directory, timestamped_filepath)
    end

    def upstream_timestamped_filepath
      File.join(upstream_directory, timestamped_filepath)
    end

    private

    attr_reader :local_directory, :upstream_directory, :filepath, :errors

    def local_filepath
      File.join(local_directory, filepath)
    end

    def timestamped_filepath
      today = Time.now.strftime('_%Y-%m-%d_%H-%M-%S')
      extname = File.extname(filepath)
      basepath = filepath.dup
      basepath.slice!(extname)
      @timestamped_filepath ||= basepath + today + extname
    end
  end
end
