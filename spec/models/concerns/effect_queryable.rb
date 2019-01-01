# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::EffectQueryable, type: :concern do
  subject { {}.extend(Concerns::Effectable) }

  it "should initialize effect properly" do
    subject.dummy_effect = { stack: :permanent }
    expect(subject.dummy_effect.active?).to eq true
  end

  context "#active?" do
    context "should be true when" do
      after { expect(subject.efx.active?).to eq(true) }

      it "permanent effect" do subject.efx = { stack: :permanent } end
      it "stacked effect" do subject.efx = { stack: 3 } end
      it "durational effect" do subject.efx = { duration: 3 } end
    end

    context "should be false when" do
      after { expect(subject.efx.active?).to eq(false) }

      it "emptied stacked effect" do subject.efx = { stack: 0 } end
      it "expired durational effect" do subject.efx = { duration: 0 } end
    end
  end
end
