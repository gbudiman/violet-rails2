# frozen_string_literal: true

module Concerns
  module Attributable
    VALID_MECHANICS = [:limit, :trance, :orb, :impulse, :malice, :mana, :soul, :gestalt, :prayer]
    VALID_STATS = [:str, :agi, :dex, :int, :vit, :fai] + VALID_MECHANICS
    VALID_RESOURCES = VALID_MECHANICS + [:hp, :weight]
  end
end
