# frozen_string_literal: true

module Violet
  module Skills
    class Stance
      include Concerns::Stateable
      SKILLS = []
      cattr_reader :effects do
        %i[]
      end

      def initialize(state)
        super
      end
    end
  end
end
