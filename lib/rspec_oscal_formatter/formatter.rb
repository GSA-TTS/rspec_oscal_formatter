# frozen_string_literal: true

module RSpecOscalFormatter
  # Common methods for PlanFormatter and ResultsFormatter
  module Formatter
    def self.included(klass)
      RSpec::Core::Formatters.register klass, :start, :example_finished, :dump_summary
    end

    attr_reader :assessment_started

    def start(notification)
      @assessment_started = RSpec::Core::Time.now
      super
    end

    def example_finished(notification)
      metadata = SpecMetadata.new(notification.example)

      return unless metadata.output_oscal?
      raise ArgumentError, "#{metadata.errors} for #{notification.example.location}" unless metadata.valid?

      assessment_examples << metadata
    end

    def assessment_examples
      @assessment_examples ||= []
    end
  end
end
