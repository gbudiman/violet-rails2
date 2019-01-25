# frozen_string_literal: true

module Concerns
  module Equippable
    module EquipWeaponizable
      include Concerns::Equippable::EquipQueryable

      def usable?
        !sundered? && !maimed?
      end

      def maim!
        self[:maimed] = true
      end

      def maimed?
        self[:maimed] == true
      end

      def sunder!
        drop!
        self[:sundered] = true
      end

      def sundered?
        self[:sundered] == true
      end

      def pristine!
        delete(:maimed)
        delete(:sundered)
      end

      def repair!; end

      def disarm!(forced: true) # rubocop:disable Lint/UnusedMethodArgument
        cached = dup
        clear
        cached
      end

      def drop!
        disarm!(forced: false)
      end

      def holster!; end

      def equip!(item); end

      def pickup!(item); end

      def method_missing(_meth, *_args)
        false
      end
    end
  end
end
