# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe RSpecOscalFormatter::Configuration do
  describe "#assessment_plan_uuid" do
    let(:uuid) { SecureRandom.uuid }

    it "returns a default uuid by default" do
      expect(subject.assessment_plan_uuid).to match(/\A[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}\z/i)
      expect(subject.assessment_plan_uuid).not_to eq uuid
    end

    it "returns a constent default" do
      expect(subject.assessment_plan_uuid).to eq subject.assessment_plan_uuid
    end

    it "allows for setting a value" do
      subject.assessment_plan_uuid = uuid
      expect(subject.assessment_plan_uuid).to eq uuid
    end
  end

  describe "#plan_filename" do
    it "returns a placeholder filename by default" do
      expect(subject.plan_filename).to eq "./assessment-plan.json"
    end

    it "allows for setting a new value" do
      subject.plan_filename = Pathname("/doc/compliance/oscal/assessment-plan.json")
      expect(subject.plan_filename).to eq "/doc/compliance/oscal/assessment-plan.json"
    end
  end

  describe "#ssp_filename" do
    it "returns a placeholder filename by default" do
      expect(subject.ssp_filename).to eq "./system-security-plan.json"
    end

    it "allows for setting a new value" do
      subject.ssp_filename = Pathname("/doc/compliance/oscal/system-security-plan.json")
      expect(subject.ssp_filename).to eq "/doc/compliance/oscal/system-security-plan.json"
    end
  end
end
