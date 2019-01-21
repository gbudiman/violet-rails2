# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      include Concerns::SkillQueryable
      
      SKILLS = [:shield_slinger]

      cattr_reader :effects do
        %i[shield_slinger]
      end

      def initialize(state)
        super
      end

      private

      def shield_slinger
        passive do
          state.push_effect(stack: :permanent, callback: -> (agent) {
            agent.equipments.holding(:shield).each do |anatomy, equipment|
              equipment.callbacks(:shield_slinger, :weight_reduction, lambda {
                equipment.weight /= 2
              })
            end
          })
        end
      end
    end
  end
end
