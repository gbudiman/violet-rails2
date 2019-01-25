# frozen_string_literal: true

module Violet
  module Skills
    class Limit
      include Concerns::Stateable
      SKILLS = %i[limit_mechanics limit_redux limit_steel_lung].freeze
      cattr_reader :effects do
        %i[]
      end

      def initialize(state)
        super
        resources.limit.max = stats.limit * 3 / 4 if skills.has_all?(:limit_break_mechanics, :limit_break_redux)
      end
    end
  end
end
