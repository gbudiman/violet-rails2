# frozen_string_literal: true

module Concerns
  module Effectable
    def actives
      self.select { |k, v| v.active? }
    end

    def inactives
      self.select { |k, v| !v.active? }
    end

    def method_missing(m, *args, &block)
      if m.to_s.last == "="
        h = args.first

        if h[:stack].present? && h[:duration].present?
          raise ArgumentError, "Only either :stack or :duration qualifier may be present, not both"
        elsif h[:stack].blank? && h[:duration].blank?
          raise ArgumentError, "Either :stack or :duration must be specified"
        end

        self[m[0..-2].to_sym] = h.extend(Concerns::EffectQueryable)
      else
        self[m]
      end
    end
  end
end
