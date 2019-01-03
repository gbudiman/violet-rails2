module Concerns
  module Statable
    def self.extended(base)
      Concerns::Attributable::VALID_STATS.each do |key|
        define_method("#{key}=") do |value|
          self[key] = { base: value }.extend(Concerns::Statable::Summable)
        end

        define_method("#{key}!") do
          self[key].sum
        end

        define_method("#{key}") do
          StatableProxy.new(self, key)
        end
      end 
    end

    def import!(h)
      Concerns::Attributable::VALID_STATS.each do |key|
        self.send("#{key}=", h[key] || 0)
      end

      self
    end

    def attributes
      Concerns::Attributable::VALID_STATS
    end

    def accessor
      Concerns::Attributable::ACCESSOR_STAT
    end

    def identifier
      :stat
    end  

    class StatableProxy
      attr_reader :field_accessor
      delegate :aux, :auxes, :base, to: :field_accessor
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

    module Summable
      def base
        self[:base] || 0
      end

      def aux
        self.select { |k, v| k != :base }.values.reduce(0, :+)
      end

      def auxes
        self.select { |k, v| k != :base }
      end

      def sum
        self.values.reduce(0, :+)
      end
    end
  end
end
