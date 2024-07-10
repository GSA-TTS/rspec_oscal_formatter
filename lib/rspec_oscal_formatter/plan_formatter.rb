# frozen_string_literal: true

require 'rspec/core'
RSpec::Support.require_rspec_core 'formatters/base_formatter'

module RSpecOscalFormatter
  # Core PlanFormatter class to output assessment plans
  class PlanFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :example_finished, :stop

    def example_finished(notification)
      metadata = SpecMetadata.new(notification.example)

      return unless metadata.output_oscal?
      raise ArgumentError, "#{metadata.errors} for #{notification.example.location}" unless metadata.valid?

      assessment_examples << metadata
    end

    def stop(_notification)
      output.puts '['
      output.puts assessment_examples.map { |m| CreateAssessmentPlan.new(m).to_json }.join(",\n")
      output.puts ']'
    end

    def assessment_examples
      @assessment_examples ||= []
    end
  end
end
