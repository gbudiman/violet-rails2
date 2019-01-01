# frozen_string_literal: true

module Concerns
  module AttributeSummable
    extend ActiveSupport::Concern

    def self.extended(base)
      base.extend(Concerns::AttributeAccessible)
      base.class::VALID_ATTRIBUTES.each do |key|
        define_method("#{key}!") do
          instance_variable_get("@#{key}").to_i
        end
      end
    end
  end
end
