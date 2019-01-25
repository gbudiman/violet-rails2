# frozen_string_literal: true

module Concerns
  module Effectable
    def self.extended(base)
      base.class.include Violet
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school).effects.each do |effect|
          key = effect.to_sym
          define_method(key) { self[key] }
          define_method("#{key}=") do |hsh|
            self[key] = define_effect(hsh).extend(Concerns::EffectQueryable)
          end
        end
      end
    end

    def actives
      select { |_k, v| v.active? }
    end

    def inactives
      reject { |_k, v| v.active? }
    end

    def define_effect(hsh)
      return hsh if hsh[:stack].present? ^ hsh[:duration].present?

      raise ExclusiveStackDurationViolation, 'Either :stack xor :duration qualifier must be supplied.'
    end

    def import!(hsh)
      hsh.each do |k, v|
        send(k, v)
      end

      self
    end

    class ExclusiveStackDurationViolation < StandardError
    end
  end
end
