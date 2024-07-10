# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe RSpecOscalFormatter::PlanFormatter do
  let(:output) { StringIO.new }
  subject { described_class.new output }

  describe '#example_finished' do
    let(:description) { 'validates encryption in transit' }
    let(:example) do
      double('Example',
             { metadata: metadata, full_description: description, execution_result: double(status: :passed) })
    end
    let(:notification) { double('Notification', example: example) }

    context 'no control_id given' do
      let(:metadata) { {} }

      it 'does not write to output' do
        subject.example_finished(notification)
        expect(output.string).to be_empty
      end
    end

    context 'with a control id' do
      let(:control_id) { 'sc-8.1' }
      let(:metadata) do
        {
          control_id: control_id,
          assessment_plan_uuid: 'febd64ce-ff1b-4b6c-a6fa-a00ca19b7b74',
          statement_id: 'sc-8.1_smt'
        }
      end

      it 'creates an assessment plan' do
        subject.example_finished(notification)
        expect(output.string).not_to be_empty
      end
    end
  end
end
