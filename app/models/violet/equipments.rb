# frozen_string_literal: true

module Violet
  module Equipments
    VALID_PROPS = %i[
      sword
      steel
      throwable
    ]
    extend ActiveSupport::Concern

    def compute_current_weight!
      current_weight = 0

      equipments.each do |_anatomy, equipment|
        current_weight += equipment.execute_callback(:weight_reduction) do
          equipment[:weight]
        end
      end

      resources.weight = current_weight
    end
  end
end
