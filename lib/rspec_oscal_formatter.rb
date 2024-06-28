# frozen_string_literal: true

require 'rspec/core'
require 'date'
require 'pathname'

Dir[File.join(__dir__, 'rspec_oscal_formatter', '*.rb')].each { |file| require file }

# To format the output of Rspec tests as OSCAL Assessment Plans and Assessment Results
module RSpec
  module RSpecOscalFormatter
    # Core class for the formatter
    class Formatter
      RSpec::Core::Formatters.register self, :example_finished, :close

      attr_reader :output

      def initialize(output)
        @output = output
      end

      def example_finished(notification)
        metadata = SpecMetaDataParser.new(notification.example)

        return unless metadata.control_id.present?

        output.open("#{metadata.control_id}-assessment-plan.json") do |f|
          f.write(CreateAssessmentPlan.new(metadata).to_json)
        end

        output.open("#{metadata.control_id}-assessment-result.json") do |f|
          f.write(CreateAssessmentResult.new(metadata).to_json)
        end
      end

      def close(_)
        return if output.closed?

        output.puts
        output.flush
      end
    end

    class OutputWrapper < Core::OutputWrapper
      attr_reader :output_directory

      def initialize(directory, create_timestamp: false)
        @output_directory = create_output_directory(directory, create_timestamp)
        super($stdout)
      end

      def open(filename, &block)
        File.open(output_directory.join(filename), 'w', &block)
      end

      private

      # Generate a timestamped directory to save the files
      def create_output_directory(dir, create_timestamp)
        example_out_dir = create_timestamp ? dir.join(DateTime.now.iso8601) : dir
        # We should raise an exception here if we can't create the directory
        example_out_dir.mkpath unless example_out_dir.exist? && example_out_dir.directory?
        example_out_dir
      end
    end
  end
end
