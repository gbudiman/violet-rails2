module Concerns
  module Weaponizable
    extend ActiveSupport::Concern

    included do
      def equip_equipments
        equipments.to_h.each do |intended_anatomy, equipment|
          case anatomy[intended_anatomy].to_sym
          when :ok
            equipments[intended_anatomy].status = :equipped
          when :maimed, :sundered
            equipments[intended_anatomy].status = :unequippable
          else
            raise Violet::Anatomies::UnknownLimbState, "Unknown limb state: #{anatomy[intended_anatomy].to_sym}"
          end
        end
      end
    end
  end
end