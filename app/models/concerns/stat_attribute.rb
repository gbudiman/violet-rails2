# frozen_string_literal: true

module Concerns
  module StatAttribute
    def attributes
      Concerns::Attributable::VALID_STATS
    end
  end
end
