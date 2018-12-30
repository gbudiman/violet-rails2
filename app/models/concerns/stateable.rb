# frozen_string_literal: true

module Concerns
  module Stateable
    extend ActiveSupport::Concern

    included do
      attr_accessor :state
      delegate_missing_to :state
    end

    def initialize(state)
      @state = state
    end
  end
end
