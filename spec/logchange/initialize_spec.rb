require 'spec_helper'
require 'fileutils'

describe Logchange::Initialize do
  let(:sample_path) { File.absolute_path(File.join(File.dirname(__FILE__), '..', 'sample')) }
  let(:directory) { "#{Time.now.utc.year}#{Time.now.utc.month.to_s.rjust(2, '0')}" }
  let(:filename) { "#{Time.now.utc.day.to_s.rjust(2, '0')}-added-logchange-to-project.yaml" }

  before do
    Logchange.configuration.root_path = sample_path
  end

  describe '#execute' do
    context 'when changes directory does not exist' do
      it 'initializes logchange' do
        expect {
          subject.execute
        }.to change { File.directory?(File.join(sample_path, 'changelog')) }.from(false).to(true)

        # Expect a change file to be present.
        latest_logs = Dir[File.join(sample_path, 'changelog', directory, filename)]
        expect(latest_logs).to_not eq([])

        # Cleanup: remove the changelog directory.
        FileUtils.rm(File.join(sample_path, 'changelog', directory, filename))
        FileUtils.rmdir(File.join(sample_path, 'changelog', directory))
        FileUtils.rmdir(File.join(sample_path, 'changelog'))
      end
    end

    context 'when changes directory exists' do
      it 'does not re-initialize logchange' do
        FileUtils.mkdir_p(File.join(sample_path, 'changelog', directory))
        subject.execute

        # The initial log should not be created.
        latest_logs = Dir[File.join(sample_path, 'changelog', directory, filename)]
        expect(latest_logs).to eq([])

        # Clean up.
        FileUtils.rmdir(File.join(sample_path, 'changelog', directory))
        FileUtils.rmdir(File.join(sample_path, 'changelog'))
      end
    end
  end
end
