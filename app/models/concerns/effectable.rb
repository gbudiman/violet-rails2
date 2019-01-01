# frozen_string_literal: true

module Concerns
  module Effectable
    def method_missing(m, *args, &block)
      if m.to_s.last == '='
        self[m[0..-2].to_sym] = args.first
      else
      end
    end
  end
end
