# frozen_string_literal: true

module Violet
  MODULES = %i[anatomies skills effects stats resources].freeze

  ANATOMIES = %i[arm feet hand head hip torso].freeze
  SKILLS = %i[
    stance limit shield
  ].freeze
  EFFECTS = [:callback].freeze
  STATS = [].freeze
  RESOURCES = [:weight].freeze

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
