# frozen_string_literal: true

module Violet
  module Equipments
    extend ActiveSupport::Concern

    included do
      def anatomies_holding(target)
        equipments.select do |anatomy, eq|
          eq[:props].map(&:to_sym).include?(target)
        end.to_h.keys
      end
    end

    def compute_current_weight!
      current_weight = 0

      equipments.each do |anatomy, equipment|
        current_weight += equipment.execute_callback(:weight_reduction) do
          equipment[:weight]
        end
      end

      resources.weight = current_weight
    end
  end
end
