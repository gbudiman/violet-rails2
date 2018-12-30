# frozen_string_literal: true

require "rails_helper"

RSpec.describe OpenStruct, type: :monkey_patch do
  subject do
    OpenStruct.new(
      a: true,
      b: true,
      c: false
    )
  end

  it { expect(subject.has_all?(:a, :b)).to eq true }
  it { expect(subject.has_all?(:a, :b, :c)).to eq false }
  it { expect(subject.has_all?(:a, :b, :c, :d)).to eq false }
  it { expect(subject.has_one?(:b, :c)).to eq true }
  it { expect(subject.has_one?(:b, :c, :d)).to eq true }
  it { expect(subject.has?(:a)).to eq true }
  it { expect(subject.has?(:c)).to eq false }
  it { expect(subject.has?(:d)).to eq false }
end
