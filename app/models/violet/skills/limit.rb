# frozen_string_literal: true

module Violet
  module Skills
    class Limit
      include Concerns::Stateable
      SKILLS = [:mechanics, :redux, :steel_lung]
      EFFECTS = []

      def initialize(state)
        super
        if skills.has_all?(:limit_break_mechanics, :limit_break_redux)
          resources.limit.max = stats.limit * 3 / 4
        end
      end
    end
  end
end
