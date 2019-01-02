# frozen_string_literal: true

module Concerns
  module AttributeAccessible
    extend ActiveSupport::Concern

    def self.extended(base)
      base.attributes.each do |key|
        define_method(key) do
          base[key]
        end

        define_method("#{key}=") do |value|
          base[key] = value
        end
      end
    end
  end
end
