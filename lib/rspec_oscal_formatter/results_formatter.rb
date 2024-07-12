# frozen_string_literal: true

RSpec::Support.require_rspec_core "formatters/base_formatter"

module RSpecOscalFormatter
  # Core ResultsFormatter class to output results
  class ResultsFormatter < RSpec::Core::Formatters::BaseFormatter
    include Formatter

    def dump_summary(notification)
      output.write CreateAssessmentResult.new(assessment_examples, assessment_started, notification.duration).to_json
    end
  end
end
