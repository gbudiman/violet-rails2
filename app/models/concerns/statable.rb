# frozen_string_literal: true

module Concerns
  module Statable
    def self.extended(base)
      base.extend(Concerns::Proxyable)
    end

    def accessor
      :base
    end

    def valid_attributes
      Concerns::Attributable::VALID_STATS
    end

    def extension
      Concerns::Statable::Summable
    end

    module Summable
      def aux
        self.select { |k, v| k != :base }.values.reduce(0, :+)
      end

      def auxes
        self.select { |k, v| k != :base }
      end

      def to_i
        self.values.reduce(0, :+)
      end
    end
  end
end
