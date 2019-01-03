module Concerns
  module Resourceable
    def self.extended(base)
      Concerns::Attributable::VALID_RESOURCES.each do |key|
        define_method("#{key}=") do |value|
          self[key] = { current: value }.extend(Concerns::Resourceable::Queryable)
        end

        define_method("#{key}!") do
          self[key].current
        end

        define_method("#{key}") do
          StatableProxy.new(self, key)
        end
      end 
    end

    def import!(h)
      Concerns::Attributable::VALID_RESOURCES.each do |key|
        self.send("#{key}=", h[key] || 0)
      end

      self
    end

    class StatableProxy
      attr_reader :field_accessor
      delegate :current, to: :field_accessor
      def initialize(ancestor, attribute)
        @ancestor = ancestor
        @attribute = attribute
        @field_accessor = @ancestor[@attribute]
      end

      def method_missing(m, *args)
        if m.to_s.last == '='
          @ancestor[@attribute]["#{m[0..-2]}".to_sym] = args.first
        else
          @ancestor[@attribute][m]
        end
      end
    end

    module Queryable
      def current
        self[:current] || 0
      end
    end
  end
end
