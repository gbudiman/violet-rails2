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

    def method_missing(m, *args, &block) 
      if m.to_s.last == '='
        arg = args.first
        if arg.is_a?(Hash)
          self[m[0..-2].to_sym] = arg.extend(Concerns::EffectQueryable)
        end
      else
        self[m]
      end
    end
  end
end