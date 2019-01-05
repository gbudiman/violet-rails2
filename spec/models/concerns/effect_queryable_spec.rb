# frozen_string_literal: true

require "rails_helper"

module EffectQueryTestable
  def self.extended(base)
    [:dummy_effect, :efx].each do |key|
      define_method(key) do
        self[key]
      end

      define_method("#{key}=") do |h|
        self[key] = define_effect(h).extend(Concerns::EffectQueryable)
      end
    end
  end
end

RSpec.describe Concerns::EffectQueryable, type: :model do
  subject { {}.extend(Concerns::Effectable, EffectQueryTestable) }

  it "should initialize effect properly" do
    subject.dummy_effect = { stack: :permanent }
    expect(subject.dummy_effect.active?).to eq true
  end

  context "invalid initialization" do
    it "should reject initialization given both stack and duration" do
      expect do
        subject.dummy_effect = { stack: :permanent, duration: 30 }
      end.to raise_error(ArgumentError, /^Only either/)
    end

    it "should reject initialization without either stack or duration" do
      expect do
        subject.dummy_effect = {}
      end.to raise_error(ArgumentError, /^Either/)
    end
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

  context "#-" do
    context "on permanent effect" do
      it "should stay permanent" do
        subject.efx = { stack: :permanent }
        subject.efx - 1
        expect(subject.efx).to eq(stack: :permanent)
      end
    end

    context "on stacked effect" do
      before { subject.efx = { stack: 12 } }
      it "should reduce the stack accordingly" do
        subject.efx - 8
        expect(subject.efx).to eq(stack: 4)
      end

      it "should not reduce the stack below 0" do
        subject.efx - 25
        expect(subject.efx).to eq(stack: 0)
      end
    end

    context "on durational effect" do
      before { subject.efx = { duration: 30 } }
      it "should reduce the duration accordingly" do
        subject.efx - 15.1
        expect(subject.efx.duration).to be_within(0.2).of(14.9)
      end

      it "should not reduce the duration below 0" do
        subject.efx - 49.4
        expect(subject.efx).to eq(duration: 0)
      end
    end
  end

  context "#tick!" do
    context "on permanent effect" do
      it "should stay permanent" do
        subject.efx = { stack: :permanent }
        expect(subject.efx.tick!).to eq(stack: :permanent)
      end
    end

    context "on stacked effect" do
      it "should reduce the stack accordingly" do
        subject.efx = { stack: 12 }
        expect(subject.efx.tick!).to eq(stack: 11)
      end

      it "should not reduce the stack below 0" do
        subject.efx = { stack: 0 }
        expect(subject.efx.tick!).to eq(stack: 0)
      end
    end

    context "on durational effect" do
      it "should reduce the duration accordingly" do
        subject.efx = { duration: 12.3 }
        expect(subject.efx.tick!.duration).to be_within(0.2).of(11.3)
      end

      it "should not reduce the duration below 0" do
        subject.efx = { duration: 0.1 }
        expect(subject.efx.tick!.duration).to eq(0)
      end
    end
  end

  context "#suppress!" do
    context "on permanent effect" do
      it "should be suppressed and revertible" do
        subject.efx = { stack: :permanent }
        expect(subject.efx.suppress!).to eq(stack: :suppressed)
        expect(subject.efx.suppress!(false)).to eq(stack: :permanent)
      end
    end

    context "on stacked effect" do
      it "should reduce stack to zero and remain zero when unsuppressed" do
        subject.efx = { stack: 12 }
        expect(subject.efx.suppress!).to eq(stack: 0)
        expect(subject.efx.suppress!(false)).to eq(stack: 0)
      end
    end

    context "on durational effect" do
      it "should reduce duration to zero and remain zero when unsuppressed" do
        subject.efx = { duration: 12.3 }
        expect(subject.efx.suppress!).to eq(duration: 0)
        expect(subject.efx.suppress!(false)).to eq(duration: 0)
      end
    end
  end
end
