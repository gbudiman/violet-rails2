# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      include Concerns::SkillQueryable

      SKILLS = [:shield_slinger].freeze

      cattr_reader :effects do
        %i[shield_slinger]
      end

      def initialize(state)
        super
      end

      private

      def shield_slinger
        passive do
          state.push_effect(stack: :permanent, callback: lambda { |agent|
            agent.anatomies.holding(:shield).each do |_name, anatomy|
              anatomy.callbacks(:shield_slinger, :weight_reduction, lambda {
                anatomy.weight /= 2
              })
            end
          })
        end
      end
    end
  end
end
