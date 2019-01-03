# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::Skillable, type: :concern do
  subject { {}.extend(Concerns::Skillable) }

  it "should initialize skill properly" do
    subject.limit_redux = true
    expect(subject.limit_redux).to eq true
  end
end