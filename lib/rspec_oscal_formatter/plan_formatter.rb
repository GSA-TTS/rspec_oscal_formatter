# frozen_string_literal: true

RSpec::Support.require_rspec_core 'formatters/base_formatter'

module RSpecOscalFormatter
  # Core PlanFormatter class to output assessment plans
  class PlanFormatter < RSpec::Core::Formatters::BaseFormatter
    include Formatter

    def dump_summary(_notification)
      output.write CreateAssessmentPlan.new(assessment_examples).to_json
    end
  end
end
