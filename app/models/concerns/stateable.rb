# frozen_string_literal: true

module Concerns
  module Stateable
    extend ActiveSupport::Concern
    mattr_accessor :preqs do
      {}
    end

    included do
      attr_accessor :state
      delegate_missing_to :state
    end

    class_methods do
      def prerequisites_for(skill, prerequisites)
        Concerns::Stateable.preqs[skill] ||= []
        Concerns::Stateable.preqs[skill] += Array.wrap(prerequisites)
      end
    end

    def initialize(state)
      @state = state
    end
  end
end
