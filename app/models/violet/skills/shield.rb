# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      include Concerns::Stateable
      SKILLS = [:shield_slinger]
      EFFECTS = [:shield_slinger]

      def initialize(state)
        super

        if skills.has?(:shield_slinger)
          effects.shield_slinger = {
            stack: :permanent,
            callback: -> (agent) {
              agent.anatomies_holding(:shield).each do |anatomy|
                agent.equipments[anatomy].callbacks_for_weight ||= []
                agent.equipments[anatomy].callbacks_for_weight.push(lambda {
                  agent.equipments[anatomy].weight / 2
                })
              end
            }
          }
        end
      end
    end
  end
end
