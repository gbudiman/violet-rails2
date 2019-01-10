module Concerns
  module Equippable
    extend ActiveSupport

    def self.extended(base)
      (Concerns::Anatomiable::VALID_ANATOMIES).each do |anatomy|
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
        self.send("#{k}=", v)
      end

      self
    end

    class EquippableProxy
      def initialize(ancestor, attribute)
        @ancestor = ancestor
        @attribute = attribute
        @target = @ancestor[@attribute]
      end

      def available?
        @target.is_a?(Hash)
      end

      def equippable?
        !@target.nil? && @target.blank?
      end

      def method_missing(m, *args)
        @target.public_send(m, *args)
      end
    end

    module EquipQueryable
      def define! prop, values
        case prop
        when :props
          values.each do |value|
            define_singleton_method("#{value}?") { true }
          end
        when :weight
          self[prop] = values
          define_singleton_method(prop) { self[prop] }
          define_singleton_method("#{prop}=") { |v| self[prop] = v }
        end
      end

      def holding_something?
        self.key?(:props) && self.key?(:weight)
      end

      def method_missing(m, *args)
        false
      end
    end

    module EquipWeaponizable
      include EquipQueryable

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
        self.delete(:maimed)
        self.delete(:sundered)
      end

      def repair!
      end

      def disarm!(forced: true)
        cached = self.dup
        self.clear
        cached
      end

      def drop!
        disarm!(forced: false)
      end

      def holster!
      end

      def equip! item
      end

      def pickup! item
      end

      def method_missing(m, *args)
        false
      end
    end
  end
end
