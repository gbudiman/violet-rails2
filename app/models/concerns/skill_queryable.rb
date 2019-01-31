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

    def available?(loc)
      @state.skills.has?(loc.label.to_sym)
    end

    def passive
      yield if available?(caller_locations(1, 1)[0])
    end

    def active
      yield if available?(caller_locations(1, 1)[0])
    end
  end
end
