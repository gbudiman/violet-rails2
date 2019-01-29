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

      prerequisites_map(
        stance_bulwark: :stance_vigilance,
        stance_colossus: :stance_vigilance,
        stance_recovery: :stance_vigilance,
        stance_mobility: :stance_bulwark,
        stance_aggression: :stance_colossus,
        stance_focus: :stance_recovery,
        stance_phalanx: [:stance_mobility, :stance_aggression, :stance_focus],
        stance_vigilance_keen_eyes: :stance_vigilance,
        stance_bulwark_bladestorm: :stance_bulwark,
        stance_colossus_deadlock: :stance_colossus,
        stance_aggression_shield_durability: :stance_aggression,
        stance_aggression_quicken: :stance_aggression,
        stance_aggression_continuum: :stance_aggression,
        stance_recovery_deft_block: :stance_recovery,
        stance_phalanx_extension: :stance_phalanx,
        stance_phalanx_gap: :stance_phalanx_extension,
        stance_phalanx_polearm: :stance_phalanx_gap
      )

      # prerequisites_for :stance_vigilance_keen_eyes, :stance_vigilance
      # prerequisites_for :stance_bulwark_bladestorm, :stance_bulwark
      # prerequisites_for :stance_bulwark, :stance_vigilance
      # prerequisites_for :stance_colossus, :stance_vigilance
      # prerequisites_for :stance_recovery, :stance_vigilance

      def initialize(state)
        super
      end
    end
  end
end
