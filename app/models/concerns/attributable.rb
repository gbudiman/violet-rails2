# frozen_string_literal: true

module Concerns
  module Attributable
    VALID_MECHANICS = [:limit, :trance, :orb, :impulse, :malice, :mana, :soul, :gestalt, :prayer]
    VALID_STATS = [:str, :agi, :dex, :int, :vit, :fai] + VALID_MECHANICS
    VALID_RESOURCES = VALID_MECHANICS + [:hp, :weight]
    extend ActiveSupport::Concern

    def initialize(valid_attributes, base_accessor = :base, **kwargs)
      valid_attributes.each do |key|
        instance_variable_set("@#{key}", {
          (base_accessor || :base) => kwargs[key] || 0
        }.extend(Concerns::Auxable))
      end
    end
  end
end
