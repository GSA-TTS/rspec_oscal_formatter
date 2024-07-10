# frozen_string_literal: true

require 'rspec/core'
RSpec::Support.require_rspec_core 'formatters/base_formatter'

module RSpecOscalFormatter
  # Core ResultsFormatter class to output results
  class ResultsFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :example_finished

    def example_finished(notification)
      metadata = SpecMetadata.new(notification.example)

      return unless metadata.output_oscal?
      raise ArgumentError, metadata.errors unless metadata.valid?

      output.write CreateAssessmentResult.new(metadata).to_json
    end
  end
end
