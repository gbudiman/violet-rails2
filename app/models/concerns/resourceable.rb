# frozen_string_literal: true

module Concerns
  module Resourceable
    def self.extended(base)
      base.extend(Concerns::Proxyable)
    end

    def accessor
      :current
    end

    def valid_attributes
      Concerns::Attributable::VALID_RESOURCES
    end

    def extension
      Concerns::Resourceable::Queryable
    end

    module Queryable
      def to_i
        self[:current] || 0
      end
    end
  end
end
