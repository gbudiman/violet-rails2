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

    def -(arg)
      if self[:stack].present? && self[:stack].is_a?(Integer)
        self[:stack] = [0, self[:stack] - arg].max
      elsif self[:duration].present?
        self[:duration] = [0, self[:duration] - arg].max
      end

      self
    end

    def suppress!(val = true)
      if val
        if self[:stack].present?
          self[:stack] = if self[:stack].is_a?(Integer)
            0
          elsif self[:stack].is_a?(Symbol)
            :suppressed
          end
        elsif self[:duration].present?
          self[:duration] = 0
        end
      else
        self[:stack] = :permanent if self[:stack] == :suppressed
      end

      self
    end

    def tick!
      self - 1
    end

    def duration
      self[:duration]
    end

    def stack
      self[:stack]
    end
  end
end
