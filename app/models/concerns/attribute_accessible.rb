module Concerns
  module AttributeAccessible
    extend ActiveSupport::Concern

    def self.extended(base)
      base.class::VALID_ATTRIBUTES.each do |key|
        define_method(key) do
          instance_variable_get("@#{key}")
        end
      end
    end
  end
end