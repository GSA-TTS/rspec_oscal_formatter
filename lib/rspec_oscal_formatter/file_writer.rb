# frozen_string_literal: true

require 'date'

module RSpecOscalFormatter
  # FileWriter responsible for creating output directories and opening files for writing there
  class FileWriter
    attr_reader :output_directory

    def initialize
      @output_directory = create_output_directory
    end

    def write(filename)
      File.open(output_directory.join(filename), 'w') do |f|
        f.write(yield)
      end
    end

    private

    # Generate a timestamped directory to save the files
    def create_output_directory
      dir = RSpecOscalFormatter.configuration.output_directory
      example_out_dir = RSpecOscalFormatter.configuration.use_timestamp_dirs? ? dir.join(DateTime.now.iso8601) : dir
      # We should raise an exception here if we can't create the directory
      example_out_dir.mkpath unless example_out_dir.exist? && example_out_dir.directory?
      example_out_dir
    end
  end
end
