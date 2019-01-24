# frozen_string_literal: true

module Concerns
  module Proxyable
    def self.extended(base)
      base.valid_attributes.each do |key|
        define_method("#{key}=") do |value|
          self[key] ||= {}.extend(base.extension)
          self[key][base.accessor] = value
        end

        define_method("#{key}!") do
          self[key].to_i
        end

        define_method("#{key}") do
          ExtensionProxy.new(self, key)
        end

        define_method(:import!) do |h|
          base.valid_attributes.each do |k|
            self.send("#{k}=", h[k] || 0)
          end

          self
        end
      end
    end

    class ExtensionProxy < BaseProxy
      attr_accessor :field_accessor
      delegate :aux, :auxes, :to_i, to: :field_accessor

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
