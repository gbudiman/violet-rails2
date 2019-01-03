# frozen_string_literal: true

module Violet
  module Skills
    class Stance
      include Concerns::Stateable
      SKILLS = []
      EFFECTS = []

      def initialize(state)
        super
      end
    end
  end
end
