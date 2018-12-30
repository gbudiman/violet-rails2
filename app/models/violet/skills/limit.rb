# frozen_string_literal: true

module Violet
  module Skills
    class Limit
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
        @state = state
        if skills.has_all?(:limit_break_mechanics, :limit_break_redux)
          resources.limit.max = stats.limit * 3 / 4
        end
      end
    end
  end
end
