module Violet
  module Effects
    class Callback
      include Concerns::Stateable
      include Violet::Equipments

      def initialize(state)
        super
        effects.each do |effect, values|
          values[:callback].call(self) if values[:callback].present?
        end
      end
    end
  end
end