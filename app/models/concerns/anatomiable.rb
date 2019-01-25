# frozen_string_literal: true

module Concerns
  module Anatomiable
    VALID_ANATOMIES = [
      :hand_main, :hand_off, # weapon slots
      :arm_main, :arm_off, :foot_main, :foot_off, :head, :torso, :hip, :slingback
    ].freeze
    VALID_STATE = %i[not_available ok maimed sundered].freeze

    VALID_ANATOMIES.each do |anatomy|
      define_method("#{anatomy}=") do |value|
        value = value.to_sym
        raise InvalidState, "Invalid State: #{value} on Anatomy: #{anatomy}" unless VALID_STATE.include?(value)

        self[anatomy] = value
      end

      define_method("#{anatomy}!") do
        self[anatomy] || :not_available
      end

      define_method(anatomy.to_s) do
        AnatomyProxy.new(self, anatomy)
      end
    end

    def import!(hsh)
      hsh.each do |key, value|
        send("#{key}=", value)
      end

      self
    end

    def method_missing(meth, *_args)
      requested_anatomy = meth.to_s.delete('=')
      raise InvalidAnatomy, "Invalid Anatomy: #{requested_anatomy}"
    end

    class InvalidAnatomy < StandardError
    end

    class InvalidState < StandardError
    end

    class AnatomyProxy < BaseProxy
      def maim!
        @ancestor[@attribute] = :maimed
      end

      def sunder!
        @ancestor[@attribute] = :sundered
      end

      def pristine!
        @ancestor[@attribute] = :ok unless @ancestor.send("#{@attribute}!") == :not_available
      end

      def repair!
        @ancestor[@attribute] = case @ancestor.send("#{@attribute}!")
                                when :sundered then :maimed
                                when :maimed then :ok
                                when :ok then :ok
        end # rubocop:disable Layout/EndAlignment
      end

      def ok?
        @ancestor.send("#{@attribute}!") == :ok
      end
    end
  end
end
