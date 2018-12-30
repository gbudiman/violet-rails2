# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
        @state = state
        ap "called from shield"
        ap @state
      end
    end
  end
end
