# frozen_string_literal: true

module Concerns
  module Anatomiable
    module AnatomyWeaponizable
      def self.extended(base)
        base.extend(Concerns::Anatomiable::AnatomyQueryable)
      end

      def holster!; end

      def pickup!(item); end

      def method_missing(_meth, *_args)
        false
      end
    end
  end
end
