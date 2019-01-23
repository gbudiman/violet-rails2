# frozen_string_literal: true

module Concerns
  module SkillQueryable
    extend ActiveSupport::Concern
    include Concerns::Stateable

    def initialize(state)
      super
      effects.each do |effect|
        send(effect)
      end
    end

    def passive
      if @state.skills.has?(caller_locations(1, 1)[0].label.to_sym)
        yield
      end
    end
  end
end
