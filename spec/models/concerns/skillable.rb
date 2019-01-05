# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::Skillable, type: :model do
  subject { {}.extend(Concerns::Skillable) }

  it "should initialize skill properly" do
    subject.limit_redux = true
    expect(subject.send("limit_redux!")).to eq true
  end

  it "should correctly return the skill availability state" do
    subject.limit_mechanics = true
    expect(subject.limit_mechanics?).to eq true
    expect(subject.limit_redux?).to eq false
  end

  context 'temporary disabler' do
    before do
      subject.limit_redux = true
      expect(subject.has?(:limit_redux)).to eq true
    end

    it 'should allow temporarily disabling skills' do
      subject.disable!(:limit_redux)
      expect(subject.has?(:limit_redux)).to eq false
      expect(subject.has?(:limit_redux, any_state: true)).to eq true
    end
  end
end
