# frozen_string_literal: true

module Violet
  module Skills
    class Shield
      include Concerns::Stateable

      def initialize(state)
        @state = state
      end
    end
  end
end
