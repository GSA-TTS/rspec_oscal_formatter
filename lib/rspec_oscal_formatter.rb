# frozen_string_literal: true

require_relative 'rspec_oscal_formatter/version'
require 'rspec/core'

# To format the output of Rspec tests as OSCAL Assessment Plans and Assessment Results
module RSpecOscalFormatter
  autoload :CommonAssemblies,       'rspec_oscal_formatter/common_assemblies'
  autoload :Configuration,          'rspec_oscal_formatter/configuration'
  autoload :CreateAssessmentPlan,   'rspec_oscal_formatter/create_assessment_plan'
  autoload :CreateAssessmentResult, 'rspec_oscal_formatter/create_assessment_result'
  autoload :Formatter,              'rspec_oscal_formatter/formatter'
  autoload :PlanFormatter,          'rspec_oscal_formatter/plan_formatter'
  autoload :ResultsFormatter,       'rspec_oscal_formatter/results_formatter'
  autoload :SpecMetadata,           'rspec_oscal_formatter/spec_metadata'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
