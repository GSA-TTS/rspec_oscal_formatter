# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe RSpecOscalFormatter::SpecMetadata do
  let(:description) { "validates encryption in transit" }
  let(:example_notification) do
    double("Example",
      {metadata: metadata, full_description: description, location: __FILE__,
       execution_result: double(status: :passed)})
  end
  subject { described_class.new example_notification }

  context "no control_id given" do
    let(:metadata) { {} }

    describe "#output_oscal?" do
      it { expect(subject.output_oscal?).to be false }
    end
  end

  context "with valid oscal metadata" do
    let(:metadata) do
      {
        control_id: "sc-8.1",
        statement_id: "sc-8.1_smt"
      }
    end

    describe "#output_oscal?" do
      it { expect(subject.output_oscal?).to be true }
    end

    describe "#valid?" do
      it { expect(subject).to be_valid }
    end

    describe "#errors" do
      it "is a blank string" do
        subject.valid?
        expect(subject.errors).to eq ""
      end
    end

    describe "#rule_ids" do
      it "returns an empty array when metadata missing" do
        expect(subject.rule_ids).to eq []
      end

      context "single rule_id" do
        let(:rule) { "system-roles-needed" }
        let(:metadata) { {rule_ids: rule} }

        it "returns an array" do
          expect(subject.rule_ids).to eq [rule]
        end
      end

      context "multiple rules" do
        let(:rules) { ["system-roles-needed", "app-account-management"] }
        let(:metadata) { {rule_ids: rules} }

        it "returns the array" do
          expect(subject.rule_ids).to eq rules
        end
      end
    end
  end

  context "with invalid oscal metadata" do
    let(:metadata) do
      {
        control_id: "sc-8.1"
      }
    end

    describe "#output_oscal?" do
      it { expect(subject.output_oscal?).to be true }
    end

    describe "#valid?" do
      it { expect(subject).not_to be_valid }
    end

    describe "#errors" do
      it "returns the error messages" do
        subject.valid?
        expect(subject.errors).to eq "statement_id is missing"
      end
    end
  end
end
