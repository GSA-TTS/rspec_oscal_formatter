# frozen_string_literal: true

require 'securerandom'

module RSpecOscalFormatter
  # Configuration - global formatter configuration
  class Configuration
    attr_writer :plan_filename, :ssp_filename, :assessment_plan_uuid

    def assessment_plan_uuid
      @assessment_plan_uuid ||= SecureRandom.uuid
    end

    def plan_filename
      (@plan_filename ||= './assessment-plan.json').to_s
    end

    def ssp_filename
      (@ssp_filename ||= './system-security-plan.json').to_s
    end
  end
end
