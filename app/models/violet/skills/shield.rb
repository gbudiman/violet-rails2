# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      include Concerns::Stateable

      def initialize(state)
        super

        if skills.has?(:shield_slinger)
          effects.shield_slinger = { 
            stack: :permanent, 
            effect: Proc.new { 
              
            }
          }
        end
      end
    end
  end
end
