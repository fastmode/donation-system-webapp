# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/file_helper'

RSpec.describe Deploy::FileHelper do
  let(:args) do
    {
      filepath: 'css/main.css',
      local_directory: 'local',
      upstream_directory: 'upstream'
    }
  end
  let(:helper) { described_class.new(args) }

  before { allow(Time).to receive(:now).and_return(time_now) }

  describe('#append_timestamp') do
    it 'copies file and adds timestamp to its filename' do
      expect(FileUtils)
        .to receive(:cp)
        .with('local/css/main.css', 'local/css/main_2017-01-01_15-00-00.css')
      helper.append_timestamp
    end

    it 'adds timestamp to filename if no problems copying' do
      path = Tempfile.new('temp.css').path
      temp_args = args.merge(
        filepath: File.basename(path),
        local_directory: File.dirname(path)
      )
      helper = described_class.new(temp_args)
      expect(helper.append_timestamp).to be_empty
    end

    it 'does not copy or timestamp if file path not found' do
      helper = described_class.new(args.merge(filepath: 'bar'))
      message = described_class::ERROR_MESSAGES[:timestamping_error]
      expect(helper.append_timestamp).to include(/#{message}/)
    end
  end

  describe('#undo_append_timestamp') do
    let(:helper) do
      path = Tempfile.new('temp.js').path
      temp_args = args.merge(
        filepath: File.basename(path),
        local_directory: File.dirname(path)
      )
      described_class.new(temp_args)
    end

    it 'works if timestamped file exists' do
      helper.append_timestamp
      expect(helper.undo_append_timestamp).to be_empty
    end

    it 'deletes timestamped file' do
      expect(File).to receive(:delete).with(/temp_2017-01-01_15-00-00.js/)
      helper.undo_append_timestamp
    end

    it 'has errors if timestamped file does not exist' do
      message = described_class::ERROR_MESSAGES[:deleting_error]
      expect(helper.undo_append_timestamp).to include(/#{message}/)
    end
  end

  it 'knows the local timestamped filepath' do
    local = 'local/css/main_2017-01-01_15-00-00.css'
    expect(helper.local_timestamped_filepath).to eq(local)
  end

  it 'knows the upstream timestamped filepath' do
    upstream = 'upstream/css/main_2017-01-01_15-00-00.css'
    expect(helper.upstream_timestamped_filepath).to eq(upstream)
  end

  it 'adds timestamp if file has no extension' do
    helper = described_class.new(args.merge(filepath: 'foo'))
    timestamped = 'local/foo_2017-01-01_15-00-00'
    expect(helper.local_timestamped_filepath).to eq(timestamped)
  end

  def time_now
    @time_now ||= Time.new(2017, 1, 1, 15, 0, 0)
  end
end
