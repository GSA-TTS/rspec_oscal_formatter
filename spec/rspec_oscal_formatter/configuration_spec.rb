# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe RSpecOscalFormatter::Configuration do
  describe '#plan_filename' do
    it 'returns a placeholder filename by default' do
      expect(subject.plan_filename).to eq './assessment-plan.json'
    end

    it 'allows for setting a new value' do
      subject.plan_filename = Pathname('/doc/compliance/oscal/assessment-plan.json')
      expect(subject.plan_filename).to eq '/doc/compliance/oscal/assessment-plan.json'
    end
  end

  describe '#ssp_filename' do
    it 'returns a placeholder filename by default' do
      expect(subject.ssp_filename).to eq './system-security-plan.json'
    end

    it 'allows for setting a new value' do
      subject.ssp_filename = Pathname('/doc/compliance/oscal/system-security-plan.json')
      expect(subject.ssp_filename).to eq '/doc/compliance/oscal/system-security-plan.json'
    end
  end
end
