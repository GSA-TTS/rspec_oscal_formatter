# frozen_string_literal: true

require "date"
require "securerandom"

require "oscal"
require "json"

module RSpecOscalFormatter
  # Creates an Assessment Result from an RSpec Unit Test Run
  class CreateAssessmentResult
    include CommonAssemblies

    attr_reader :start_time, :end_time

    def initialize(examples, start_time, duration)
      @examples = examples
      @start_time = start_time.to_datetime
      @end_time = (@start_time + duration).to_datetime
    end

    def assessment_result
      @assessment_result ||= Oscal::AssessmentResult::AssessmentResult.new(
        {
          uuid: SecureRandom.uuid,
          metadata: build_metadata_block,
          import_ap: {href: RSpecOscalFormatter.configuration.plan_filename},
          results: [create_results_block]
        }
      )
    end

    def to_json(*_args)
      JSON.pretty_generate({"assessment-results": assessment_result.to_h})
    end

    private

    def build_metadata_block
      {
        title: RSpecOscalFormatter.configuration.results_title,
        last_modified: DateTime.now.iso8601,
        version: DateTime.now.iso8601,
        oscal_version: "1.1.2"
      }
    end

    def create_results_block
      {
        uuid: SecureRandom.uuid,
        title: "Automated rspec results for #{DateTime.now.iso8601}",
        description: "Results for tests:\n\n#{examples.map(&:description).uniq.map { |d| "  * #{d}" }.join("\n")}",
        start: start_time.iso8601,
        end: end_time.iso8601,
        reviewed_controls: build_reviewed_controls,
        observations: create_observations,
        findings: create_findings
      }
    end

    def create_observations
      examples.map do |metadata|
        {
          uuid: SecureRandom.uuid,
          title: title(metadata),
          description: "Test contents:\n```#{metadata.test_source}```",
          methods: ["TEST"],
          types: ["finding"],
          collected: start_time.iso8601,
          props: [test_source_prop(metadata)] + metadata.statement_ids.map do |sid|
                                                  finding_uuid_prop(metadata, sid)
                                                end
        }
      end
    end

    def finding_uuid_prop(metadata, statement_id)
      {
        "name" => "Finding_UUID",
        "value" => metadata.finding_uuid(statement_id),
        "remarks" => statement_id
      }
    end

    def create_findings
      examples.flat_map do |metadata|
        metadata.statement_ids.map do |statement_id|
          {
            uuid: metadata.finding_uuid(statement_id),
            title: title(metadata),
            description: "#{metadata.control_id}: #{metadata.inspect_output}",
            target: create_target(metadata, statement_id),
            implementation_statement_uuid: metadata.implementation_statement_uuid
          }.compact
        end
      end
    end

    def title(metadata)
      "#{metadata.control_id}: #{metadata.description}"
    end

    def create_target(metadata, statement_id)
      {
        type: "statement-id",
        target_id: statement_id,
        status: {
          state: metadata.state,
          reason: metadata.reason
        },
        props: [test_source_prop(metadata)]
      }
    end

    def test_source_prop(metadata)
      {
        "name" => "Test_Source_Location",
        "value" => metadata.location
      }
    end
  end
end
