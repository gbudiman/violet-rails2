# frozen_string_literal: true

class BaseProxy
  def initialize(ancestor, attribute)
    @ancestor = ancestor
    @attribute = attribute
    @field_accessor = @ancestor[@attribute]
  end
end
