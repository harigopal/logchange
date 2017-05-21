require 'spec_helper'
require 'fileutils'

describe Logchange::Logger do
  subject { described_class.new(title) }

  let(:title) { 'This is a test title' }
  let(:sample_path) { File.absolute_path(File.join(File.dirname(__FILE__), '..', 'sample')) }
  let(:directory) { "#{Time.now.utc.year}#{Time.now.utc.month.to_s.rjust(2, '0')}" }
  let(:day_component) { Time.now.utc.day.to_s.rjust(2, '0') }

  before do
    Logchange.configuration.root_path = sample_path
    FileUtils.mkdir(File.join(sample_path, 'changelog'))
  end

  after do
    FileUtils.rmdir(File.join(sample_path, 'changelog'))
  end

  describe '#execute' do
    let(:filename) { "#{day_component}-this-is-a-test-title.yaml" }

    after do
      FileUtils.rm(File.join(sample_path, 'changelog', directory, filename))
      FileUtils.rmdir(File.join(sample_path, 'changelog', directory))
    end

    it 'creates a public changelog file' do
      subject.execute
      log = YAML.load(File.read(File.join(sample_path, 'changelog', directory, filename)))
      expect(log['public']).to eq(true)
      expect(log['title']).to eq(title)
    end

    context 'when the title is really long' do
      let(:title) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id erat odio. Vestibulum molestie lacus dapibus elit molestie, quis lacinia urna venenatis. Cras lobortis erat quis condimentum vehicula. Phasellus dapibus.' }
      let(:filename) { "#{day_component}-lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit-cras-i.yaml" }

      it 'restricts the filename to 64 characters' do
        subject.execute
        log = YAML.load(File.read(File.join(sample_path, 'changelog', directory, filename)))
        expect(log['title']).to eq(title)
      end
    end

    context 'when the title contains special characters' do
      let(:title) { "This title contains 4 special characters. Surprising! Isn't it?" }
      let(:filename) { "#{day_component}-this-title-contains-4-special-characters-surprising-isnt-it.yaml" }

      it 'removes all special characters from filename' do
        subject.execute
        log = YAML.load(File.read(File.join(sample_path, 'changelog', directory, filename)))
        expect(log['title']).to eq(title)
      end
    end

    context 'when there is a custom template' do
      it 'merges keys from custom template into generated log file' do
        template_path = File.join(sample_path, 'changelog', 'template.yaml')

        template_contents = YAML.dump(
          'public' => false,
          'github_issue' => 'Add a link to related Github issue, or delete this key.'
        )

        File.write(template_path, template_contents)

        subject.execute
        log = YAML.load(File.read(File.join(sample_path, 'changelog', directory, filename)))
        expect(log['title']).to eq(title)
        expect(log['github_issue']).to eq('Add a link to related Github issue, or delete this key.')
        expect(log['public']).to eq(false)

        # Expect another random key to be missing.
        expect(log['foo']).to eq(nil)

        FileUtils.rm(template_path)
      end
    end
  end
end
