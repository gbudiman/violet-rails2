module Concerns
  module Resourceable
    def self.extended(base)
      base.extend(Concerns::Baseable)
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
      def current
        self[:current] || 0
      end

      def to_i
        current
      end
    end
  end
end
