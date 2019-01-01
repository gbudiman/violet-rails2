# frozen_string_literal: true

module Concerns
  module EffectQueryable
    def active?
      if self[:stack].present?
        return true if self[:stack].is_a?(Symbol) && self[:stack] == :permanent
        return true if self[:stack].is_a?(Integer) && self[:stack] > 0
      elsif self[:duration].present?
        return true if self[:duration] > 0
      end

      false
    end
  end
end
