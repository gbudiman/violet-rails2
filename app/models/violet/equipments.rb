# frozen_string_literal: true

module Violet
  module Equipments
    VALID_PROPS = %i[
      sword
      shield
      leather
      steel
      throwable
    ].freeze
    extend ActiveSupport::Concern

    def compute_current_weight!
      current_weight = 0

      anatomies.each do |_name, anatomy|
        current_weight += anatomy.execute_callback(:weight_reduction) do
          anatomy.weight
        end
      end

      resources.weight = current_weight
    end
  end
end
