# frozen_string_literal: true

module RSpecOscalFormatter
  # Tiny helper class to provide easy access to the metadata attributes in the spec.
  class SpecMetadata
    STATUS_MAP = {
      passed: 'pass',
      failed: 'fail',
      pending: 'other'
    }.freeze

    attr_reader :control_id, :description, :statement_id, :reason, :state

    def initialize(example)
      @control_id = example.metadata[:control_id]
      @description = example.full_description
      @statement_id = example.metadata[:statement_id]
      @reason = STATUS_MAP[example.execution_result.status]
      @state = @reason == 'pass' ? 'satisfied' : 'not-satisfied'
    end

    def output_oscal?
      !nil_or_empty?(control_id)
    end

    def valid?
      @errors = []
      @errors << 'statement_id is missing' if nil_or_empty?(statement_id)
      @errors << 'description is missing' if nil_or_empty?(description)
      @errors.empty?
    end

    def errors
      @errors ||= []
      @errors.join(', ')
    end

    private

    def nil_or_empty?(attr)
      attr.nil? || attr.empty?
    end
  end
end
