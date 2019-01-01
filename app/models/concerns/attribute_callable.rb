module Concerns
  module AttributeCallable
    extend ActiveSupport::Concern

    def self.extended(base)
      base.class::VALID_ATTRIBUTES.each do |key|
        define_method(key) do
          instance_variable_get("@#{key}")
        end

        define_method("#{key}!") do
          instance_variable_get("@#{key}").send(base.class::BASE_ACCESSOR)
        end
      end
    end
  end
end