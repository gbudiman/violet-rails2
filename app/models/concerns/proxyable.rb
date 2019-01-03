# frozen_string_literal: true

module Concerns
  module Proxyable
    def self.extended(base)
      base.valid_attributes.each do |key|
        define_method("#{key}=") do |value|
          self[key] = { base.accessor => value }.extend(base.extension)
        end

        define_method("#{key}!") do
          self[key].to_i
        end

        define_method("#{key}") do
          ExtensionProxy.new(self, key)
        end

        define_method(:import!) do |h|
          base.valid_attributes.each do |key|
            self.send("#{key}=", h[key] || 0)
          end

          self
        end
      end
    end

    class ExtensionProxy
      attr_reader :field_accessor
      delegate :aux, :auxes, :to_i, to: :field_accessor

      def initialize(ancestor, attribute)
        @ancestor = ancestor
        @attribute = attribute
        @field_accessor = @ancestor[@attribute]
      end

      def method_missing(m, *args)
        if m.to_s.last == "="
          @ancestor[@attribute]["#{m[0..-2]}".to_sym] = args.first
        else
          @ancestor[@attribute][m]
        end
      end
    end
  end
end
