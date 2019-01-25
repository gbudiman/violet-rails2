# frozen_string_literal: true

module Concerns
  module Proxyable
    def self.extended(base)
      base.valid_attributes.each do |key|
        define_method("#{key}=") do |value|
          self[key] ||= {}.extend(base.extension)
          self[key][base.accessor] = value
        end

        define_method("#{key}!") { self[key].to_i }
        define_method(key.to_s) { ExtensionProxy.new(self, key) }
        define_method(:import!) do |h|
          base.valid_attributes.each do |k|
            send("#{k}=", h[k] || 0)
          end

          self
        end
      end
    end

    class ExtensionProxy < BaseProxy
      attr_accessor :field_accessor
      delegate :aux, :auxes, :to_i, to: :field_accessor

      def method_missing(meth, *args)
        if meth.to_s.last == '='
          @ancestor[@attribute][(meth[0..-2]).to_s.to_sym] = args.first
        else
          @ancestor[@attribute][meth]
        end
      end
    end
  end
end
