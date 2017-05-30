require 'spec_helper'

describe Logchange::InteractiveLogger do
  let(:template) {
    {
      'github_issue_link' => 'Add link to related Github issue.',
      'private' => 'Hide this change from the public? Set to true or false.'
    }
  }

  let(:title) { 'This is a new feature' }
  let(:github_issue_link) { 'https://github.com/harigopal/logchange/issues/1' }

  describe '#execute' do
    it 'accept required information from user through console' do
      allow(Logchange::Template).to receive(:load).and_return(template)
      allow(STDIN).to receive(:gets).and_return(title, github_issue_link, 'false')

      logger = instance_double(Logchange::Logger)
      expect(Logchange::Logger).to receive(:new).with(title, template: { 'github_issue_link' => github_issue_link, 'private' => false }).and_return(logger)
      expect(logger).to receive(:execute)

      subject.execute
    end

    context 'when a template key is skipped' do
      it 'is excluded from the output' do
        allow(Logchange::Template).to receive(:load).and_return(template)
        allow(STDIN).to receive(:gets).and_return(title, '', 'true')

        logger = instance_double(Logchange::Logger)
        expect(Logchange::Logger).to receive(:new).with(title, template: { 'private' => true }).and_return(logger)
        expect(logger).to receive(:execute)

        subject.execute
      end
    end
  end
end
