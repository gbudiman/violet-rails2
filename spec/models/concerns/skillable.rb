# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::Skillable, type: :concern do
  subject { {}.extend(Concerns::Skillable) }

  it "should initialize skill properly" do
    subject.limit_redux = true
    expect(subject.limit_redux).to eq true
  end

  it "should correctly return the skill availability state" do
    subject.limit_mechanics = true
    expect(subject.limit_mechanics?).to eq true
    expect(subject.limit_redux?).to eq false
  end
end