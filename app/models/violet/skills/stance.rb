# frozen_string_literal: true

module Violet
  module Skills
    class Stance
      include Concerns::Stateable
      SKILLS = %i[
        stance_vigilance
        stance_vigilance_keen_eyes
        stance_bulwark
        stance_bulwark_bladestorm
        stance_colossus
        stance_colossus_deadlock
        stance_aggression
        stance_aggression_shield_durability
        stance_aggression_quicken
        stance_aggression_continuum
        stance_recovery
        stance_recovery_deft_block
        stance_phalanx
        stance_phalanx_extension
        stance_phalanx_gap
        stance_phalanx_polearm
        stance_mobility
        stance_focus
      ].freeze
      cattr_reader :effects do
        %i[
          stance_vigilance
          keen_eyes
          stance_bulwark
          bladestorm
          stance_colossus
          colossus_deadlock
          stance_aggression
          aggression_shield_durability
          aggression_quicken
          agression_continuum
          stance_recovery
          deft_block
          stance_phalanx
          phalanx_extension
          phalanx_gap
          phalanx_polearm
          stance_mobility
          stance_focus
        ]
      end

      prerequisites_for :stance_vigilance_keen_eyes, :stance_vigilance
      prerequisites_for :stance_bulwark_bladestorm, :stance_bulwark

      def initialize(state)
        super
      end
    end
  end
end
