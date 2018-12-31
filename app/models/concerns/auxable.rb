module Concerns
  module Auxable
    def to_i
      self.map{ |k, v| v }.reduce(0, :+)
    end

    def base
      self[:base]
    end

    def aux
      auxes.values.reduce(0, :+)
    end

    def auxes
      self.reject{ |k, v| k == :base }
    end

    def method_missing(m, *args, &block)
      if m.to_s.last == '='
        self[m[0..-2].to_sym] = args.first
      else
        self[m]
      end
    end
  end
end