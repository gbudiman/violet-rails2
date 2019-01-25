# frozen_string_literal: true

module Concerns
  module MultiQueryable
    def all?(*args)
      args.map { |x| has?(x) }.reduce(true) { |a, b| a && b }
    end

    def one?(*args)
      args.map { |x| has?(x) }.reduce(false) { |a, b| a || b }
    end

    def all!(value, *args)
      args.map { |x| send("#{x}=", value) }
    end
  end
end
