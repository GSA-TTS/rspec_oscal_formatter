# frozen_string_literal: true

require "forwardable"
require "method_source"

module RSpecOscalFormatter
  # Tiny helper class to provide easy access to the metadata attributes in the spec.
  class SpecMetadata
    extend Forwardable

    STATUS_MAP = {
      passed: "pass",
      failed: "fail",
      pending: "other"
    }.freeze

    attr_reader :example, :control_id, :statement_ids, :objective_ids, :reason, :state, :implementation_statement_uuid, :rule_ids

    def_delegator :example, :full_description, :description
    def_delegators :example, :location, :inspect_output

    def initialize(example)
      @example = example
      @control_id = example.metadata[:control_id]
      @statement_ids = Array(example.metadata[:statement_id])
      @objective_ids = Array(example.metadata[:objective_id])
      @implementation_statement_uuid = example.metadata[:implementation_statement_uuid]
      @rule_ids = Array(example.metadata[:rule_ids])
      @reason = STATUS_MAP[example.execution_result.status]
      @state = (@reason == "pass") ? "satisfied" : "not-satisfied"
    end

    def output_oscal?
      !nil_or_empty?(control_id)
    end

    def valid?
      @errors = []
      @errors << "control_id is missing" if nil_or_empty?(control_id)
      @errors << "statement_id or objective_id is missing" if target_references.empty?
      @errors << "reason was invalid" if nil_or_empty?(reason)
      @errors.empty?
    end

    def errors
      @errors ||= []
      @errors.join(", ")
    end

    def test_source
      example.metadata[:block]&.source
    end

    def finding_uuid(statement_id)
      @finding_uuid_map ||= Hash.new { |h, k| h[k] = SecureRandom.uuid }
      @finding_uuid_map[statement_id]
    end

    def target_references
      @target_references ||=
        statement_ids.map { |statement_id| {type: "statement-id", id: statement_id} } +
        objective_ids.map { |objective_id| {type: "objective-id", id: objective_id} }
    end

    private

    def nil_or_empty?(attr)
      attr.nil? || attr.empty?
    end
  end
end
