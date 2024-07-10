# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe RSpecOscalFormatter::PlanFormatter do
  let(:output) { StringIO.new }
  subject { described_class.new output }
  let(:description) { 'validates encryption in transit' }
  let(:control_id) { 'sc-8.1' }
  let(:metadata) do
    {
      control_id: control_id,
      statement_id: 'sc-8.1_smt'
    }
  end
  let(:example) do
    double('Example',
           { metadata: metadata, full_description: description, execution_result: double(status: :passed) })
  end
  let(:example_notification) { double('ExampleNotification', example: example) }

  describe '#example_finished' do
    context 'no control_id given' do
      let(:metadata) { {} }

      it 'does not collect the example metadata' do
        subject.example_finished(example_notification)
        expect(subject.assessment_examples).to be_empty
      end
    end

    context 'with a control id' do
      it 'collects the example metadata for future use' do
        subject.example_finished(example_notification)
        expect(subject.assessment_examples).not_to be_empty
      end
    end
  end

  describe '#stop' do
    let(:examples_notification) { double('ExamplesNotification') }

    before do
      subject.example_finished(example_notification)
    end

    it 'outputs the assessment plan' do
      subject.stop(examples_notification)
      expect(output.string).not_to be_empty
    end
  end
end
