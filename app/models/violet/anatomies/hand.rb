module Violet
  module Anatomies
    class Hand
      include Concerns::Weaponizable
      attr_accessor :state
      delegate_missing_to :state

      def initialize(state)
        @state = state
        equip_equipments
      end
    end
  end
end