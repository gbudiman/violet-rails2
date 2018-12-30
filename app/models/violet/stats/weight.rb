# frozen_string_literal: true

module Violet
  module Stats
    class Weight
      include Concerns::Stateable
      include Violet::Equipments

      def initialize(state)
        super
        resources.weight ||= {}
        resources.weight.max = 8 * Math.log2(2 + stats.str)

        compute_current_weight!
      end
    end
  end
end
