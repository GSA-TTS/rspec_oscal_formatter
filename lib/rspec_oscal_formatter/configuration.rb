# frozen_string_literal: true

module RSpecOscalFormatter
  # Configuration - global formatter configuration
  class Configuration
    attr_writer :plan_filename, :ssp_filename

    def plan_filename
      if @plan_filename.nil?
        './assessment-plan.json'
      else
        @plan_filename.to_s
      end
    end

    def ssp_filename
      if @ssp_filename.nil?
        './system-security-plan.json'
      else
        @ssp_filename.to_s
      end
    end
  end
end
