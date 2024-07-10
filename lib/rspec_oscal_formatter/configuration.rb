# frozen_string_literal: true

module RSpecOscalFormatter
  # Configuration - global formatter configuration
  class Configuration
    attr_writer :output_directory

    def output_directory
      if @output_directory.nil?
        raise ArgumentError,
              'You must set RSpecOscalFormatter.configuration.output_directory before adding the formatter'
      end
      Pathname(@output_directory)
    end

    def use_timestamp_dirs!
      @use_timestamp_dirs = true
    end

    def use_timestamp_dirs?
      !!@use_timestamp_dirs
    end
  end
end
