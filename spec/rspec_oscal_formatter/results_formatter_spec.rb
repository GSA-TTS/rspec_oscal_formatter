# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe RSpecOscalFormatter::ResultsFormatter do
  let(:output) { StringIO.new }
  subject { described_class.new output }
  let(:description) { "validates encryption in transit" }
  let(:control_id) { "sc-8.1" }
  let(:metadata) do
    {
      control_id: control_id,
      statement_id: "sc-8.1_smt"
    }
  end
  let(:example) do
    double("Example",
      {metadata: metadata, full_description: description, location: __FILE__,
       inspect_output: "\"#{description}\" (#{__FILE__})", execution_result: double(status: :passed)})
  end
  let(:example_notification) { double("ExampleNotification", example: example) }

  describe "#example_finished" do
    context "no control_id given" do
      let(:metadata) { {} }

      it "does not collect the example metadata" do
        subject.example_finished(example_notification)
        expect(subject.assessment_examples).to be_empty
      end
    end

    context "with a control id" do
      it "collects the example metadata for future use" do
        subject.example_finished(example_notification)
        expect(subject.assessment_examples).not_to be_empty
      end
    end
  end

  describe "#dump_summary" do
    let(:summary_notification) { double("SummaryNotification", duration: 1.0) }

    before do
      subject.start(double("StartNotification").as_null_object)
      subject.example_finished(example_notification)
    end

    it "outputs the assessment results" do
      subject.dump_summary(summary_notification)
      expect(output.string).not_to be_empty
    end
  end
end
