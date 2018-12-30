# frozen_string_literal: true

class OpenStruct
  def has?(arg)
    self[arg] || false
  end

  def has_all?(*args)
    args.map { |x| self[x] }.reduce(true) { |a, b| a && b }
  end

  def has_one?(*args)
    args.map { |x| self[x] }.reduce(false) { |a, b| a || b }
  end
end
