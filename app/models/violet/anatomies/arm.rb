# frozen_string_literal: true

module Violet
  module Anatomies
    class Arm
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
        @state = state
      end
    end
  end
end
