# frozen_string_literal: true

require 'rspec/core'
RSpec::Support.require_rspec_core 'formatters/base_formatter'

module RSpecOscalFormatter
  # Core Formatter class to output plans and results
  class Formatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :example_finished

    attr_reader :file_writer

    def initialize(output = nil)
      @file_writer = FileWriter.new
      super(output)
    end

    def example_finished(notification)
      metadata = SpecMetadata.new(notification.example)

      return unless metadata.output_oscal?
      raise ArgumentError, metadata.errors unless metadata.valid?

      ap_filename = "#{metadata.control_id}-assessment-plan.json"
      file_writer.write(ap_filename) do
        CreateAssessmentPlan.new(metadata).to_json
      end

      file_writer.write("#{metadata.control_id}-assessment-result.json") do
        CreateAssessmentResult.new(metadata, ap_filename).to_json
      end
    end
  end
end
