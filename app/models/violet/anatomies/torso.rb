module Violet
  module Anatomies
    class Torso
      attr_accessor :state
      delegate_missing_to :state
      
      def initialize(state)
      end
    end
  end
end