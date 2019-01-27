# frozen_string_literal: true

module Concerns
  module Anatomiable
    # VALID_ANATOMIES = [
    #   :hand_main, :hand_off, # weapon slots
    #   :arm_main, :arm_off, :foot_main, :foot_off, :head, :torso, :hip, :slingback
    # ].freeze
    VALID_WEAPONIZABLE = %i[hand_main hand_off].freeze
    VALID_EQUIPPABLE = %i[arm_main arm_off foot_main foot_off head torso hip slingback].freeze
    VALID_ANATOMIES = VALID_WEAPONIZABLE + VALID_EQUIPPABLE
    VALID_STATES = %i[not_available ok maimed sundered].freeze

    VALID_ANATOMIES.each do |anatomy|
      define_method("#{anatomy}=") do |value|
        self[anatomy.to_sym] = case anatomy
        when ->(m) { m.in?(VALID_WEAPONIZABLE) }
          value.extend(AnatomyWeaponizable)
        when ->(m) { m.in?(VALID_EQUIPPABLE) }
          value.extend(AnatomyQueryable)
        end # rubocop:disable Layout/EndAlignment
      rescue InvalidState, MissingState => exception
        raise exception, "Anatomy #{anatomy}: #{exception.message}"
      end

      define_method("#{anatomy}!") do
        self[anatomy.to_sym]&.state || :not_available
      end

      define_method(anatomy) do
        AnatomyProxy.new(self, anatomy)
      end
    end

    def import!(hsh)
      hsh.each do |key, value|
        send("#{key}=", value.dup)
      end

      self
    end

    def holding(*args)
      args.each_with_object({}) do |arg, m|
        select { |anatomy, _| send(anatomy).send("#{arg}?") }.each do |k, v|
          m[k] = v
        end
      end
    end

    def method_missing(meth, *_args)
      requested_anatomy = meth.to_s.delete('=')
      raise InvalidAnatomy, "Invalid Anatomy: #{requested_anatomy}"
    end

    class AnatomyNotAvailable < StandardError
    end

    class InvalidAnatomy < StandardError
    end

    class InvalidState < StandardError
    end

    class MissingState < StandardError
    end

    class AnatomyProxy < BaseProxy
      def available?
        @field_accessor.present?
      end

      def method_missing(meth, *args)
        raise AnatomyNotAvailable if @field_accessor.nil?

        @field_accessor.send(meth, *args)
      end
    end
  end
end
