require 'spec_helper'
require 'fileutils'

describe Logchange::Release do
  subject { described_class.new(tag) }

  let(:tag) { nil }
  let(:sample_path) { File.absolute_path(File.join(File.dirname(__FILE__), '..', 'sample')) }
  let(:changelog_path) { File.join(sample_path, 'changelog') }
  let(:unreleased_path) { File.join(changelog_path, 'unreleased') }
  let(:release_path) { File.join(changelog_path, "#{Time.now.utc.year}.yaml") }

  before do
    Logchange.configuration.root_path = sample_path
    FileUtils.cp_r(File.join(sample_path, 'sample_changelog', '.'), File.join(sample_path, 'changelog'))
  end

  after do
    FileUtils.rm(release_path) if File.exist?(release_path)
    FileUtils.rmdir(unreleased_path)
    FileUtils.rmdir(changelog_path)
  end

  context 'when there are no unreleased changes' do
    it 'prints an error message' do
      FileUtils.rm(Dir[File.join(unreleased_path, '*.yaml')])
      expect { subject.execute }.to output("There are no unreleased changes.\n").to_stdout
    end
  end

  context 'when there are unreleased changes' do
    it 'releases all unreleased changes' do
      expect { subject.execute }.to change { File.exist?(File.join(changelog_path, "#{Time.now.utc.year}.yaml")) }.from(false).to(true)

      release = YAML.safe_load(File.read(release_path))

      # There should be one release.
      expect(release['changelog'].length).to eq(1)

      # There should be a timestamp to the release.
      expect(Time.parse(release['changelog'][0]['timestamp'])).to be_a(Time)

      # There should be no release tag.
      expect(release['changelog'][0]['tag']).to eq(nil)

      # There should be three changes.
      expect(release['changelog'][0]['changes'].length).to eq(3)

      # The first change should be the latest.
      expect(release['changelog'][0]['changes'][0]['title']).to eq('Remove the public flag from default set of keys')

      # The last change should be the earliest.
      expect(release['changelog'][0]['changes'][-1]['title']).to eq('Added logchange to project.')
    end

    it 'prints a success message' do
      expect { subject.execute }.to output("Released changes to #{release_path}.\n").to_stdout
    end

    context 'when released changes already exist' do
      it 'appends to list of changes' do
        # Create the release changelog.
        subject.execute

        # Create one unreleased change.
        FileUtils.cp(File.join(sample_path, 'sample_changelog', 'unreleased', '20170522-remove-the-public-flag-from-default-set-of-keys.yaml'), File.join(sample_path, 'changelog', 'unreleased'))

        # Can't reuse 'subject'.
        Logchange::Release.new(tag).execute

        release = YAML.safe_load(File.read(release_path))

        # The changelog should have two releases.
        expect(release['changelog'].length).to eq(2)

        # The release at the top should have a single change.
        expect(release['changelog'][0]['changes'].length).to eq(1)
      end
    end

    context 'when a tag is supplied' do
      let(:tag) { 'v0.1.0' }

      it 'is recorded with the release' do
        subject.execute

        release = YAML.safe_load(File.read(release_path))

        # There should be one release.
        expect(release['changelog'].length).to eq(1)

        # There should be a release tag.
        expect(release['changelog'][0]['tag']).to eq('v0.1.0')
      end
    end
  end
end
