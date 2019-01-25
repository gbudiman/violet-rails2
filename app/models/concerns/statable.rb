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
        reject { |k, _v| k == :base }.values.reduce(0, :+)
      end

      def auxes
        reject { |k, _v| k == :base }
      end

      def to_i
        values.reduce(0, :+)
      end
    end
  end
end
