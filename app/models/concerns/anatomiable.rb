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
    end

    def maim!
      self == :maimed
    end

    def method_missing(m, *args)
      if m.to_s.last == '='
        raise InvalidAnatomy, "Invalid Anatomy: #{m.to_s[0..-2]}"
      end

      raise
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

      def ok?
        @ancestor[@anatomy] == :ok
      end
    end
  end
end