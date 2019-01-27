# frozen_string_literal: true

module Concerns
  module Weaponizable
    VALID_WEAPONIZABLE = %i[hand_main hand_off].freeze
    extend ActiveSupport::Concern
    include Concerns::Stateable

    included do
    #   def equip_equipments
    #     equipments.each do |intended_anatomy, _equipment|
    #       case anatomies[intended_anatomy].to_sym
    #       when :ok
    #         equipments[intended_anatomy].status = :equipped
    #       when :maimed, :sundered
    #         equipments[intended_anatomy].status = :unequippable
    #       else
    #         raise Violet::Anatomies::UnknownLimbState, "Unknown limb state: #{anatomy[intended_anatomy].to_sym}"
    #       end
    #     end
    #   end
    end

    def initialize(state)
      super
      #equip_equipments
    end
  end
end
