# frozen_string_literal: true

require 'rails_helper'

module EffectQueryTestable
  def self.extended(_base)
    %i[dummy_effect efx].each do |key|
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
  subject(:instance) { {}.extend(Concerns::Effectable, EffectQueryTestable) }

  it 'initializes effect properly' do
    instance.dummy_effect = { stack: :permanent }
    expect(instance.dummy_effect.active?).to eq true
  end

  context 'with invalid initialization' do
    it 'rejects initialization given both stack and duration' do
      expect do
        instance.dummy_effect = { stack: :permanent, duration: 30 }
      end.to raise_error(Concerns::Effectable::ExclusiveStackDurationViolation, /^Either/)
    end

    it 'rejects initialization without either stack or duration' do
      expect do
        instance.dummy_effect = {}
      end.to raise_error(Concerns::Effectable::ExclusiveStackDurationViolation, /^Either/)
    end
  end

  describe '#active?' do
    describe 'should be true when' do
      after { expect(instance.efx.active?).to eq(true) }

      it 'permanent effect' do instance.efx = { stack: :permanent } end
      it 'stacked effect' do instance.efx = { stack: 3 } end
      it 'durational effect' do instance.efx = { duration: 3 } end
    end

    describe 'should be false when' do
      after { expect(instance.efx.active?).to eq(false) }

      it 'emptied stacked effect' do instance.efx = { stack: 0 } end
      it 'expired durational effect' do instance.efx = { duration: 0 } end
    end
  end

  describe '#clear' do
    context 'with permanent effect' do
      before { instance.efx = { stack: :permanent } }

      it 'remains permanent' do
        instance.efx.clear!
        expect(instance.efx.stack).to eq(:permanent)
      end
    end

    context 'with non-permanent stack' do
      before { instance.efx = { stack: 15 } }

      it 'clears stack' do
        instance.efx.clear!
        expect(instance.efx.stack).to eq(0)
      end
    end

    context 'with suppressed stack' do
      before { instance.efx = { stack: :suppressed } }

      it 'remains suppressed' do
        instance.efx.suppress!
        expect(instance.efx.stack).to eq(:suppressed)
      end
    end

    context 'with durational effect' do
      before { instance.efx = { duration: 30 } }

      it 'clears duration' do
        instance.efx.clear!
        expect(instance.efx.duration).to eq(0)
      end
    end
  end

  describe '#+' do
    context 'with permanent effect' do
      before { instance.efx = { stack: :permanent } }

      it 'remains permanent' do
        instance.efx << { stack: 12 }
        expect(instance.efx.stack).to eq(:permanent)
      end
    end

    context 'with non-permanent stack' do
      before { instance.efx = { stack: 15 } }

      it 'adds to stack' do
        instance.efx << { stack: 12 }
        expect(instance.efx.stack).to eq(27)
      end

      it 'raises error on incompatible type' do
        expect do 
          instance.efx << { duration: 15 }
        end.to raise_error(Concerns::EffectQueryable::IncompatibleQualifier)
      end
    end

    context 'with suppressed stack' do
      before do
        instance.efx = { stack: :permanent }
        instance.efx.suppress!
      end

      it 'remains suppressed' do
        instance.efx << { stack: 12 }
        expect(instance.efx.suppressed?).to eq true
      end
    end

    context 'with durational effect' do
      before { instance.efx = { duration: 30 } }

      it 'adds to duration' do
        instance.efx << { duration: 30 }
        expect(instance.efx.duration).to eq(60)
      end
    end

    context 'with mismatched numerator' do
      it 'raises exception on :duration << :stack' do
        instance.efx = { duration: 30 }

        expect do
          instance.efx << { stack: 30 }
        end.to raise_error(Concerns::EffectQueryable::IncompatibleQualifier, 'Expected duration given stack')
      end

      it 'raises exception on :stack << :duration' do
        instance.efx = { stack: 30 }

        expect do
          instance.efx << { duration: 30 }
        end.to raise_error(Concerns::EffectQueryable::IncompatibleQualifier, 'Expected stack given duration')
      end
    end
  end

  describe '#-' do
    context 'with permanent effect' do
      it 'stays permanent' do
        instance.efx = { stack: :permanent }
        instance.efx -= 1
        expect(instance.efx).to eq(stack: :permanent)
      end
    end

    context 'with stacked effect' do
      before { instance.efx = { stack: 12 } }

      it 'reduces the stack accordingly' do
        instance.efx -= 8
        expect(instance.efx).to eq(stack: 4)
      end

      it 'does not reduce the stack below 0' do
        instance.efx -= 25
        expect(instance.efx).to eq(stack: 0)
      end
    end

    context 'with durational effect' do
      before { instance.efx = { duration: 30 } }

      it 'reduces the duration accordingly' do
        instance.efx -= 15.1
        expect(instance.efx.duration).to be_within(0.2).of(14.9)
      end

      it 'does not reduce the duration below 0' do
        instance.efx -= 49.4
        expect(instance.efx).to eq(duration: 0)
      end
    end
  end

  describe '#tick!' do
    context 'with permanent effect' do
      it 'stays permanent' do
        instance.efx = { stack: :permanent }
        expect(instance.efx.tick!).to eq(stack: :permanent)
      end
    end

    context 'with stacked effect' do
      it 'reduces the stack accordingly' do
        instance.efx = { stack: 12 }
        expect(instance.efx.tick!).to eq(stack: 11)
      end

      it 'does not reduce the stack below 0' do
        instance.efx = { stack: 0 }
        expect(instance.efx.tick!).to eq(stack: 0)
      end
    end

    context 'with durational effect' do
      it 'reduces the duration accordingly' do
        instance.efx = { duration: 12.3 }
        expect(instance.efx.tick!.duration).to be_within(0.2).of(11.3)
      end

      it 'does not reduce the duration below 0' do
        instance.efx = { duration: 0.1 }
        expect(instance.efx.tick!.duration).to eq(0)
      end
    end
  end

  describe '#suppress!' do
    context 'with permanent effect' do
      it 'is suppressed and revertible' do
        instance.efx = { stack: :permanent }
        expect(instance.efx.suppress!).to eq(stack: :suppressed)
        expect(instance.efx.suppress!(false)).to eq(stack: :permanent)
      end
    end

    context 'with stacked effect' do
      it 'reduces stack to zero and remain zero when unsuppressed' do
        instance.efx = { stack: 12 }
        expect(instance.efx.suppress!).to eq(stack: 0)
        expect(instance.efx.suppress!(false)).to eq(stack: 0)
      end
    end

    context 'with durational effect' do
      it 'reduces duration to zero and remain zero when unsuppressed' do
        instance.efx = { duration: 12.3 }
        expect(instance.efx.suppress!).to eq(duration: 0)
        expect(instance.efx.suppress!(false)).to eq(duration: 0)
      end
    end
  end
end
