# frozen_string_literal: true

module Violet
  module Anatomies
    class Feet
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
      end
    end
  end
end
