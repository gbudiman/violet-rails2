# frozen_string_literal: true

module Violet
  module Equipments
    extend ActiveSupport::Concern

    included do
      def compute_current_weight!
        equipments.each do |anatomy, equipment|
          if equipment[:callbacks_for_weight].is_a?(Array)
            equipment[:callbacks_for_weight].each do |callback|
              resources.weight.current += callback.call
            end
          else
            resources.weight.current += equipment[:weight]
          end
        end
      end

      def anatomies_holding(target)
        equipments.select do |anatomy, eq| 
          eq[:props].include?(target.to_s) 
        end.to_h.keys
      end
    end
  end
end
