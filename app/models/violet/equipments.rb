# frozen_string_literal: true

module Violet
  module Equipments
    extend ActiveSupport::Concern

    included do
      def compute_current_weight!
        equipments.each do |anatomy, equipment|
          
        end
      end

      def anatomies_holding(target)
        equipments.select { |anatomy, eq| eq[:props].include?(target) }.to_h.keys
      end
    end
  end
end
