# frozen_string_literal: true

module Concerns
  module Anatomiable
    module AnatomyQueryable
      def self.extended(base)
        raise MissingState unless base[:state].present?
        raise InvalidState, "Invalid State #{base[:state]}" unless base[:state].to_sym.in?(VALID_STATES)

        assign_state_query_methods!
        assign_singleton_methods!(base)
      end

      def self.assign_state_query_methods!
        VALID_STATES.each do |state|
          define_method("#{state}?") do
            self[:state] == state
          end
        end
      end

      def self.assign_singleton_methods!(base)
        base.each do |prop, values|
          case prop
          when :props
            values.each do |value|
              base.define_singleton_method("#{value}?") { true }
            end
          when :weight
            base[prop] = values
          end
        end

        base.define_singleton_method(:state) { self[:state] }
        base.define_singleton_method(:weight) { base[:weight] || 0 }
        base.define_singleton_method(:weight=) { |v| base[:weight] = v }
      end

      def holding_something?
        key?(:props) && key?(:weight)
      end

      def callbacks(name, prop, block)
        self[:callbacks] ||= {}
        self[:callbacks][name.to_sym] = {
          props: prop.is_a?(Array) ? prop : [prop],
          block: block
        }
      end

      def execute_callback(prop)
        self[:callbacks]&.each do |_key, value|
          return value[:block].call if value[:props].include?(prop)
        end

        yield
      end

      def equippable?
        !holding_something? && !sundered?
      end

      def usable?
        !sundered? && !maimed?
      end

      def maim!
        self[:state] = :maimed
      end

      def sunder!
        drop!
        self[:state] = :sundered
      end

      def pristine!
        self[:state] = :ok
      end

      def repair!
        self[:state] = case self[:state]
        when :sundered then :maimed
        when :maimed then :ok
        else self[:state]
        end # rubocop:disable Layout/EndAlignment
      end

      def equip!(item); end

      def method_missing(meth, *args)
        case meth
        when ->(m) { m[-1] == '?' }
          return false if meth[0..-2].to_sym.in?(Violet::Equipments::VALID_PROPS)
        end

        raise NoMethodError, "#{meth} with #{args}"
      end
    end
  end
end
