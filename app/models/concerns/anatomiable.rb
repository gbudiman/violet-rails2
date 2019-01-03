# frozen_string_literal: true

module Concerns
  module Anatomiable
    VALID_ANATOMIES = [
      :hand_main, :hand_off, # weapon slots
      :arm_main, :arm_off, :foot_main, :foot_off, :head, :torso, :hip, :slingback
    ]
    VALID_STATE = [:not_available, :ok, :maimed, :sundered]

    VALID_ANATOMIES.each do |anatomy|
      define_method("#{anatomy}=") do |value|
        raise InvalidState, "Invalid State: #{value} on Anatomy: #{anatomy}" unless VALID_STATE.include?(value)
        self[anatomy] = value
      end

      define_method("#{anatomy}!") do
        self[anatomy] || :not_available
      end

      define_method("#{anatomy}") do
        AnatomyProxy.new(self, anatomy)
      end
    end

    def import!(h)
      h.each do |key, value|
        self.send("#{key}=", value)
      end

      self
    end

    def method_missing(m, *args)
      if m.to_s.last == "="
        raise InvalidAnatomy, "Invalid Anatomy: #{m.to_s[0..-2]}"
      end

      raise NoMethodError
    end

    class InvalidAnatomy < StandardError
    end

    class InvalidState < StandardError
    end

    class AnatomyProxy
      attr_reader :anatomy, :ancestor
      def initialize(ancestor, anatomy)
        @anatomy = anatomy
        @ancestor = ancestor
      end

      def maim!
        @ancestor[@anatomy] = :maimed
      end

      def sunder!
        @ancestor[@anatomy] = :sundered
      end

      def pristine!
        @ancestor[@anatomy] = :ok unless @ancestor.send("#{@anatomy}!") == :not_available
      end

      def repair!
        @ancestor[@anatomy] = case @ancestor.send("#{@anatomy}!")
                              when :sundered then :maimed
                              when :maimed then :ok
                              when :ok then :ok
        end
      end

      def ok?
        @ancestor.send("#{@anatomy}!") == :ok
      end
    end
  end
end
