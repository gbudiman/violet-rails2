# frozen_string_literal: true

class State::Stat
  VALID_ATTRIBUTES = Concerns::Attributable::VALID_STATS
  BASE_ACCESSOR = :base

  include Concerns::Attributable
  def initialize(**kwargs)
    super(VALID_ATTRIBUTES, :base, kwargs)
    self.extend(Concerns::AttributeCallable)
  end
end
