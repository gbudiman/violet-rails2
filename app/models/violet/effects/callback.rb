# frozen_string_literal: true

module Violet
  module Effects
    class Callback
      include Concerns::Stateable

      def initialize(state)
        super

        effects.each do |effect, values|
          values[:callback].call(self) if values[:callback].present?
        end
      end
    end
  end
end
