# frozen_string_literal: true

module Violet
  module Equipments
    extend ActiveSupport::Concern

    included do
      def compute_current_weight!
        current_weight = 0

        equipments.each do |anatomy, equipment|
          if equipment[:callbacks_for_weight].is_a?(Array)
            equipment[:callbacks_for_weight].each do |callback|
              current_weight += callback.call
            end
          else
            current_weight += equipment[:weight]
          end
        end

        resources.weight.current = current_weight
      end

      def anatomies_holding(target)
        equipments.select do |anatomy, eq|
          eq[:props].include?(target.to_s)
        end.to_h.keys
      end
    end
  end
end
