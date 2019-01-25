# frozen_string_literal: true

module Concerns
  module Equippable
    extend ActiveSupport

    def self.extended(_base)
      Concerns::Anatomiable::VALID_ANATOMIES.each do |anatomy|
        define_method(anatomy) do
          EquippableProxy.new(self, anatomy)
        end

        define_method("#{anatomy}=") do |value|
          self[anatomy] = value.dup
          if anatomy.in?(Concerns::Weaponizable::VALID_WEAPONIZABLE)
            self[anatomy].extend(EquipWeaponizable)
          else
            self[anatomy].extend(EquipQueryable)
          end

          value.each do |prop, propval|
            self[anatomy].define!(prop, propval)
          end
        end
      end
    end

    def import!(h)
      h.each do |k, v|
        send("#{k}=", v)
      end

      self
    end

    def holding(*args)
      args.each_with_object({}) do |arg, m|
        select { |anatomy, _| send(anatomy).send("#{arg}?") }.each do |k, v|
          m[k] = v
        end
      end
    end

    class EquippableProxy < BaseProxy
      def available?
        @field_accessor.is_a?(Hash)
      end

      def equippable?
        !@field_accessor.nil? && @field_accessor.blank?
      end

      def method_missing(m, *args)
        @field_accessor.public_send(m, *args)
      end
    end
  end
end
