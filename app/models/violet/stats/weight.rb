# frozen_string_literal: true

module Violet
  module Stats
    class Weight
      include Concerns::Stateable

      def initialize(state)
        super
        resources.weight ||= {}
        resources.weight.max = 8 * Math.log2(2 + stats.str)
      end
    end
  end
end
