# frozen_string_literal: true

module Concerns
  module Equippable
    module EquipQueryable
      def define!(prop, values)
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

      def callbacks(name, prop, block)
        self[:callbacks] ||= {}
        self[:callbacks][name.to_sym] = {
          props: prop.is_a?(Array) ? prop : [prop],
          block: block
        }
      end

      def execute_callback(prop)
        self[:callbacks]&.each do |key, value|
          return value[:block].call if value[:props].include?(prop)
        end

        yield
      end

      def method_missing(m, *args)
        false
      end
    end
  end
end
