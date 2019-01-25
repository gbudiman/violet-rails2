# frozen_string_literal: true

class State::Stat
  VALID_ATTRIBUTES = Concerns::Attributable::VALID_STATS
  BASE_ACCESSOR = :base

  include Concerns::Attributable
  def initialize(**kwargs)
    super(VALID_ATTRIBUTES, BASE_ACCESSOR, kwargs)
    extend(Concerns::AttributeSummable)
  end
end
