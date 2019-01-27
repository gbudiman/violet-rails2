# frozen_string_literal: true

module Concerns
  module Anatomiable
    module AnatomyWeaponizable
      def self.extended(base)
        base.extend(Concerns::Anatomiable::AnatomyQueryable)
      end

      def holster!; end

      def pickup!(item); end

      def disarm!(forced: true) # rubocop:disable Lint/UnusedMethodArgument
        cached = self.except(:state).dup
        delete_if { |k, _v| k != :state }
        cached
      end

      def drop!
        disarm!(forced: false)
      end
    end
  end
end
