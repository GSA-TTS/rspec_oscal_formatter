# frozen_string_literal: true

require 'rspec/core'
RSpec::Support.require_rspec_core 'formatters/base_formatter'
require 'date'
require 'pathname'

Dir[File.join(__dir__, 'rspec_oscal_formatter', '*.rb')].each { |file| require file }

# To format the output of Rspec tests as OSCAL Assessment Plans and Assessment Results
module RSpec
  module RSpecOscalFormatter
    # Core class for the formatter
    class Formatter < Core::Formatters::BaseFormatter
      RSpec::Core::Formatters.register self, :example_finished

      class << self
        attr_writer :output_directory, :use_timestamp_dirs

        def use_timestamp_dirs?
          !!@use_timestamp_dirs
        end

        def output_directory
          if @output_directory.nil?
            raise ArgumentError,
                  'You must set RSpec::RSpecOscalFormatter::Formatter.output_directory before adding the formattter'
          end

          @output_directory
        end
      end
      attr_reader :file_writer

      def initialize(output)
        @file_writer = FileWriter.new self.class.output_directory, self.class.use_timestamp_dirs?
        super(output)
      end

      def example_finished(notification)
        metadata = SpecMetaDataParser.new(notification.example)

        return unless metadata.control_id.present?

        ap_filename = "#{metadata.control_id}-assessment-plan.json"
        file_writer.open(ap_filename) do |f|
          f.write(CreateAssessmentPlan.new(metadata).to_json)
        end

        file_writer.open("#{metadata.control_id}-assessment-result.json") do |f|
          f.write(CreateAssessmentResult.new(metadata, ap_filename).to_json)
        end
      end
    end

    class FileWriter
      attr_reader :output_directory

      def initialize(directory, create_timestamp)
        @output_directory = create_output_directory(directory, create_timestamp)
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
