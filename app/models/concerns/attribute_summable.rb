# frozen_string_literal: true

module Concerns
  module AttributeSummable
    extend ActiveSupport::Concern

    # def self.extended(base)
    #   base.extend(Concerns::AttributeAccessible)
    #   base.attributes.each do |key|
    #     define_method("#{key}!") do
    #       instance_variable_get("@#{key}").to_i
    #     end
    #   end
    # end
  end
end
