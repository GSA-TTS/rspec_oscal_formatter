# frozen_string_literal: true

require 'date'
require 'oscal'

module RSpecOscalFormatter
  # Create an assessment plan from the metadata and template
  class CreateAssessmentPlan
    attr_reader :assessment_plan

    def initialize(metadata)
      @assessment_plan =
        Oscal::AssessmentPlan::AssessmentPlan.new(
          {
            uuid: RSpecOscalFormatter.configuration.assessment_plan_uuid,
            metadata: build_ap_metadata_block(metadata),
            import_ssp: { href: RSpecOscalFormatter.configuration.ssp_filename },
            reviewed_controls: make_reviewed_controls(metadata)
          }
        )
    end

    def build_ap_metadata_block(metadata)
      {
        title: "Automated Testing Plan. It #{metadata.description}",
        last_modified: DateTime.now.iso8601,
        version: DateTime.now.iso8601,
        oscal_version: '1.1.2'
      }
    end

    def make_reviewed_controls(metadata)
      {
        control_selections: [
          include_controls: [
            {
              control_id: metadata.control_id,
              statement_ids: [metadata.statement_id]
            }
          ]
        ]
      }
    end

    def to_json(*_args)
      assessment_plan.to_json
    end
  end
end
