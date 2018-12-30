module Violet
  module Stats
    class Weight
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
        @state = state
        resources.weight ||= {}
        resources.weight.max = 8 * Math.log2(2 + stats.str)
      end
    end
  end
end