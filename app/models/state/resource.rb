# frozen_string_literal: true

class State::Resource
  VALID_ATTRIBUTES = Concerns::Attributable::VALID_RESOURCES
  BASE_ACCESSOR = :current

  include Concerns::Attributable
  def initialize(**kwargs)
    super(VALID_ATTRIBUTES, BASE_ACCESSOR, kwargs)
    extend(Concerns::AttributeCallable)
  end
end
