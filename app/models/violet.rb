# frozen_string_literal: true

module Violet
  MODULES = [:anatomies, :skills, :effects, :stats, :resources]

  ANATOMIES = [:arm, :feet, :hand, :head, :hip, :torso]
  SKILLS = [
    :stance, :limit, :shield
  ]
  EFFECTS = [:callback]
  STATS = []
  RESOURCES = [:weight]

  extend ActiveSupport::Concern

  included do
    def submodules_of(modules)
      "Violet::#{modules.to_s.upcase}".constantize
    end

    def class_of(mod, submod)
      "Violet::#{mod.to_s.camelize}::#{submod.to_s.camelize}".constantize
    end
  end
end
