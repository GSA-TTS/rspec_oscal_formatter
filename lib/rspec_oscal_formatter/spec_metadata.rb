# frozen_string_literal: true

require 'forwardable'
require 'method_source'

module RSpecOscalFormatter
  # Tiny helper class to provide easy access to the metadata attributes in the spec.
  class SpecMetadata
    extend Forwardable

    STATUS_MAP = {
      passed: 'pass',
      failed: 'fail',
      pending: 'other'
    }.freeze

    attr_reader :example, :control_id, :statement_ids, :reason, :state, :implementation_statement_uuid

    def_delegator :example, :full_description, :description
    def_delegators :example, :location, :inspect_output

    def initialize(example)
      @example = example
      @control_id = example.metadata[:control_id]
      @statement_ids = Array(example.metadata[:statement_id])
      @implementation_statement_uuid = example.metadata[:implementation_statement_uuid]
      @reason = STATUS_MAP[example.execution_result.status]
      @state = @reason == 'pass' ? 'satisfied' : 'not-satisfied'
    end

    def output_oscal?
      !nil_or_empty?(control_id)
    end

    def valid?
      @errors = []
      @errors << 'control_id is missing' if nil_or_empty?(control_id)
      @errors << 'statement_id is missing' if nil_or_empty?(statement_ids)
      @errors << 'reason was invalid' if nil_or_empty?(reason)
      @errors.empty?
    end

    def errors
      @errors ||= []
      @errors.join(', ')
    end

    def test_source
      example.metadata[:block]&.source
    end

    def finding_uuid(statement_id)
      @finding_uuid_map ||= Hash.new { |h, k| h[k] = SecureRandom.uuid }
      @finding_uuid_map[statement_id]
    end

    private

    def nil_or_empty?(attr)
      attr.nil? || attr.empty?
    end
  end
end
