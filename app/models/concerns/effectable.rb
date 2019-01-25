# frozen_string_literal: true

module Concerns
  module Effectable
    def self.extended(base)
      base.class.include Violet
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school).effects.each do |effect|
          key = effect.to_sym

          define_method(key) do
            self[key]
          end

          define_method("#{key}=") do |h|
            self[key] = define_effect(h).extend(Concerns::EffectQueryable)
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

    def define_effect(h)
      if h[:stack].present? && h[:duration].present?
        raise ArgumentError, 'Only either :stack or :duration qualifier may be present, not both'
      elsif h[:stack].blank? && h[:duration].blank?
        raise ArgumentError, 'Either :stack or :duration must be specified'
      end

      h
    end

    def import!(h)
      h.each do |k, v|
        send(k, v)
      end

      self
    end
  end
end
