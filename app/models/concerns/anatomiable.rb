module Concerns
  module Anatomiable
    VALID_ANATOMIES = [
      :hand_main, :hand_off, # weapon slots
      :arm_main, :arm_off, :foot_main, :foot_off, :head, :torso, :hip, :slingback
    ]

    VALID_ANATOMIES.each do |anatomy|
      define_method("#{anatomy}=") do |value|
        self[anatomy] = value
      end
    end

    def import!(h)
      h.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def method_missing(m, *args)
      if m.to_s.last == '='
        raise InvalidAnatomy, "Invalid Anatomy: #{m.to_s[0..-2]}"
      end

      raise
    end

    class InvalidAnatomy < StandardError
    end
  end
end