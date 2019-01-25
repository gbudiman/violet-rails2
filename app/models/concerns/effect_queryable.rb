# frozen_string_literal: true

module Concerns
  module EffectQueryable
    def stack?
      self[:stack].present?
    end

    def stack_numerical?
      stack? && stack.is_a?(Integer)
    end

    def duration?
      self[:duration].present?
    end

    def finite_stack?
      stack? && self[:stack].is_a?(Integer)
    end

    def duration
      self[:duration]
    end

    def stack
      self[:stack]
    end

    def permanent?
      stack? && stack.is_a?(Symbol) && stack == :permanent
    end

    def suppressed?
      stack? && stack.is_a?(Symbol) && stack == :suppressed
    end

    def active?
      (stack? && (permanent? || stack.positive?)) || (duration? && duration.positive?)
    end

    def -(other)
      if stack_numerical?
        self[:stack] = [0, stack - other].max
      elsif duration?
        self[:duration] = [0, duration - other].max
      end

      self
    end

    def <<(**kwargs)
      raise IncompatibleQualifier, 'Expected stack given duration' if stack? && kwargs[:duration].present?
      raise IncompatibleQualifier, 'Expected duration given stack' if duration? && kwargs[:stack].present?

      if stack_numerical?
        self[:stack] += kwargs[:stack]
      elsif duration?
        self[:duration] += kwargs[:duration]
      end

      self
    end

    def clear!
      if stack_numerical?
        self[:stack] = 0
      elsif duration?
        self[:duration] = 0
      end
    end

    def suppress!(val = true)
      if val
        if stack?
          self[:stack] = stack_numerical? ? 0 : :suppressed
        elsif duration?
          self[:duration] = 0
        end
      elsif suppressed?
        self[:stack] = :permanent
      end

      self
    end

    def tick!
      self - 1
    end

    class IncompatibleQualifier < StandardError
    end
  end
end
