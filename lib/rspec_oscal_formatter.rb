# frozen_string_literal: true

require_relative 'rspec_oscal_formatter/version'

# To format the output of Rspec tests as OSCAL Assessment Plans and Assessment Results
module RSpecOscalFormatter
  autoload :Configuration,          'rspec_oscal_formatter/configuration'
  autoload :CreateAssessmentPlan,   'rspec_oscal_formatter/create_assessment_plan'
  autoload :CreateAssessmentResult, 'rspec_oscal_formatter/create_assessment_result'
  autoload :FileWriter,             'rspec_oscal_formatter/file_writer'
  autoload :Formatter,              'rspec_oscal_formatter/formatter'
  autoload :SpecMetadata,           'rspec_oscal_formatter/spec_metadata'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
