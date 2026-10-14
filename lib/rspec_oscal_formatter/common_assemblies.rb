module RSpecOscalFormatter
  # Common builder methods for CreateAssessmentPlan and CreateAssessmentResult
  module CommonAssemblies
    attr_reader :examples

    private

    def grouped_examples
      @grouped_examples ||= examples.group_by(&:control_id)
    end

    def build_reviewed_controls
      {control_selections: [
        description: build_selection_description,
        include_controls: build_include_controls
      ]}
    end

    def build_selection_description
      grouped_examples.map do |cid, examples|
        <<~GROUP_DESC
          #{cid} is validated by tests for:

          #{examples.map(&:description).uniq.map { |d| "  * #{d}" }.join("\n")}

        GROUP_DESC
      end.join("\n")
    end

    def build_include_controls
      grouped_examples.map do |cid, examples|
        control = {control_id: cid}
        statement_ids = examples.flat_map(&:statement_ids).uniq
        control[:statement_ids] = statement_ids unless statement_ids.empty?

        control
      end
    end
  end
end
