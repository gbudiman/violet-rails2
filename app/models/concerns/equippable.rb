module Concerns
  module Equippable
    extend ActiveSupport

    def self.extended(base)
      Concerns::Anatomiable::VALID_ANATOMIES.each do |anatomy|
      end

      Concerns::Weaponizable::VALID_WEAPONIZABLE.each do |anatomy|
      end
    end
  end
end