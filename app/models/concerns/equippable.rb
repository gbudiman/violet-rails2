module Concerns
  module Equippable
    extend ActiveSupport

    def self.extended(base)
      (Concerns::Anatomiable::VALID_ANATOMIES).each do |anatomy|
        define_method(anatomy) do
          EquippableProxy.new(self, anatomy)
        end

        define_method("#{anatomy}=") do |value|
          self[anatomy] = value.extend(EquipQueryable)
          value.extend(EquipOperable) if anatomy.in?(Concerns::Weaponizable::VALID_WEAPONIZABLE)

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

      def disarm!
        return unless @target.disarmable?
        @ancestor[@attribute] = {}
        @target
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

      def method_missing(m, *args)
        return false
      end
    end

    module EquipOperable
      # def self.extended(base)
      #   base.define_method(:disarm!) do
      #     ap base
      #     base = {}
      #   end
      # end
      def disarmable?
        true
      end
    end
  end
end
