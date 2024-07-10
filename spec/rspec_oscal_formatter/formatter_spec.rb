# frozen_string_literal: true

require_relative '../spec_helper'
require 'tmpdir'

RSpec.describe RSpecOscalFormatter::Formatter do
  around(:each) do |example|
    Dir.mktmpdir do |tmp|
      RSpecOscalFormatter.configure do |c|
        c.output_directory = Pathname(tmp)
      end
      example.run
    end
  end

  describe '#example_finished' do
    let(:description) { 'validates encryption in transit' }
    let(:example) do
      double('Example',
             { metadata: metadata, full_description: description, execution_result: double(status: :passed) })
    end
    let(:notification) { double('Notification', example: example) }

    context 'no control_id given' do
      let(:metadata) { {} }

      it 'does not open a file_writer file' do
        writer = subject.file_writer
        expect(writer).not_to receive(:write)
        subject.example_finished(notification)
      end
    end

    context 'with a control id' do
      let(:control_id) { 'sc-8.1' }
      let(:output_directory) { RSpecOscalFormatter.configuration.output_directory }
      let(:assessment_plan_file) { File.join(output_directory, "#{control_id}-assessment-plan.json") }
      let(:assessment_result_file) { File.join(output_directory, "#{control_id}-assessment-result.json") }
      let(:metadata) do
        {
          control_id: control_id,
          assessment_plan_uuid: 'febd64ce-ff1b-4b6c-a6fa-a00ca19b7b74',
          statement_id: 'sc-8.1_smt'
        }
      end

      it 'creates an assessment plan' do
        subject.example_finished(notification)
        expect(File.exist?(assessment_plan_file)).to be true
      end

      it 'creates an assessment result' do
        subject.example_finished(notification)
        expect(File.exist?(assessment_result_file)).to be true
      end
    end
  end
end
