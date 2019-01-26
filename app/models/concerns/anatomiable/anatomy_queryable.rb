# frozen_string_literal: true

module Concerns
  module Anatomiable
    module AnatomyQueryable
      def self.extended(base)
        raise MissingState unless base[:state].present?
        raise InvalidState, "Invalid State #{base[:state]}" unless base[:state].in?(VALID_STATES)

        VALID_STATES.each do |state|
          define_method("#{state}?") do
            self[:state] == state
          end
        end
      end

      def state
        self[:state]
      end

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

      def disarm!(forced: true) # rubocop:disable Lint/UnusedMethodArgument
        cached = dup
        clear
        cached
      end

      def drop!
        disarm!(forced: false)
      end

      def equip!(item); end

      def method_missing(_meth, *_args)
        false
      end
    end
  end
end
