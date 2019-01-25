# frozen_string_literal: true

module Concerns
  module Attributable
    VALID_MECHANICS = %i[limit trance orb impulse malice mana soul gestalt prayer].freeze
    VALID_STATS = %i[str agi dex int vit fai] + VALID_MECHANICS
    VALID_RESOURCES = VALID_MECHANICS + %i[hp weight]
  end
end
