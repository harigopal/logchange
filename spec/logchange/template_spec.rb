require 'spec_helper'
require 'fileutils'

describe Logchange::Template do
  subject { described_class }

  let(:sample_path) { File.absolute_path(File.join(File.dirname(__FILE__), '..', 'sample')) }

  before do
    Logchange.configuration.root_path = sample_path
  end

  describe '.load' do
    context 'when a template file is present' do
      let(:template) { { 'key_1' => 'value_1', 'key_2' => 'value_2' } }

      it 'loads the contents of the template' do
        changelog_path = File.join(sample_path, 'changelog')
        template_path = File.join(changelog_path, 'template.yaml')
        FileUtils.mkdir(changelog_path)
        File.write(template_path, YAML.dump(template))

        expect(subject.load).to eq(template)

        FileUtils.rm(template_path)
        FileUtils.rmdir(changelog_path)
      end
    end

    context 'when there is no template file' do
      it 'returns an empty hash' do
        expect(subject.load).to eq({})
      end
    end
  end
end
