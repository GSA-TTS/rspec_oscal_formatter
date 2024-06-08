# typed: true
# frozen_string_literal: true

require 'tapioca'
require 'date'
require_relative '../oscal'

module RSpec
  module RspecOscalFormatter
    # Create an assessment plan from the metadata and template
    class CreateAssessmentPlan
      # extend T::Sig

      # sig { params(metadata: SpecMetaDataParser).void }
      def initialize(metadata)
        @assessment_plan =
          Oscal::AssessmentPlan::AssessmentPlan.new(
            {
              uuid: metadata.assessment_plan_uuid,
              metadata: build_ap_metadata_block(metadata),
              import_ssp: { href: './assessment_plan.json' },
              reviewed_controls: make_reviewed_controls(metadata),
            },
          )
      end

      # sig { params(metadata: SpecMetaDataParser).returns(Hash) }
      def build_ap_metadata_block(metadata)
        {
          title: "Automated Testing Plan for login.gov. It #{metadata.description}",
          last_modified: DateTime.now.iso8601,
          version: DateTime.now.iso8601,
          oscal_version: '1.1.2',
        }
      end

      # sig { params(metadata: SpecMetaDataParser).returns(Hash) }
      def make_reviewed_controls(metadata)
        {
          control_selections: [
            include_controls: [
              {
                control_id: metadata.control_id,
                statement_ids: [metadata.statement_id],
              },
            ],
          ],
        }
      end

      # sig { returns(Oscal::AssessmentPlan::AssessmentPlan) }
      def get
        @assessment_plan
      end

      # sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        @assessment_plan.to_json
      end
    end
  end
end