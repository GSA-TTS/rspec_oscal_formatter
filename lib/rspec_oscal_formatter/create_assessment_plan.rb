# frozen_string_literal: true

require "date"
require "oscal"
require "json"

module RSpecOscalFormatter
  # Create an assessment plan from the metadata and template
  class CreateAssessmentPlan
    include CommonAssemblies

    def initialize(examples)
      @examples = examples
    end

    def assessment_plan
      @assessment_plan ||=
        Oscal::AssessmentPlan::AssessmentPlan.new(
          {
            uuid: RSpecOscalFormatter.configuration.assessment_plan_uuid,
            metadata: build_ap_metadata_block,
            import_ssp: {href: RSpecOscalFormatter.configuration.ssp_filename},
            reviewed_controls: build_reviewed_controls
          }
        )
    end

    def to_json(*_args)
      JSON.pretty_generate({"assessment-plan": assessment_plan})
    end

    private

    def build_ap_metadata_block
      {
        title: RSpecOscalFormatter.configuration.plan_title,
        last_modified: DateTime.now.iso8601,
        version: DateTime.now.iso8601,
        oscal_version: "1.1.2"
      }
    end
  end
end
