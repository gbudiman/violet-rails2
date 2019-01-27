# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Concerns::Anatomiable, type: :model do
  subject(:instance) { {}.extend(Concerns::Anatomiable) }

  describe '#import!' do
    it 'loads anatomies from Hash correctly' do
      %i[ok maimed sundered].each do |state|
        input = { hand_main: { state: state }, hand_off: { state: state } }
        instance.import!(input)
        expect(instance.keys).to contain_exactly(*input.keys)
      end
    end

    it 'raises error when no state is given' do
      expect do
        instance.import!(hand_main: {})
      end.to raise_error(Concerns::Anatomiable::MissingState)
    end

    it 'raises error on invalid anatomy' do
      expect do
        instance.import!(invalid_limb: { state: :ok })
      end.to raise_error(Concerns::Anatomiable::InvalidAnatomy, /^Invalid Anatomy: invalid_limb/)
    end

    it 'raises error on invalid anatomy state' do
      expect do
        instance.import!(hand_main: { state: :invalid })
      end.to raise_error(Concerns::Anatomiable::InvalidState, /^Anatomy hand_main: Invalid State invalid/)
    end
  end

  context 'when not available' do
    describe 'bang method' do
      it 'returns :not_available' do
        Concerns::Anatomiable::VALID_ANATOMIES.each do |anatomy|
          expect(instance.send("#{anatomy}!")).to eq(:not_available)
        end
      end
    end
  end

  context 'when available' do
    let(:input) do
      {
        hand_main: { state: :ok },
        hand_off: { state: :sundered },
        arm_main: { state: :ok },
        head: { state: :maimed }
      }
    end

    before { instance.import!(input) }

    describe 'bang method' do
      it 'returns proper state' do
        input.each do |anatomy, value|
          expect(instance.send("#{anatomy}!")).to eq(value[:state])
        end
      end

      it 'queries state correctly' do
        input.each do |anatomy, value|
          expect(instance.send(anatomy).send("#{value[:state]}?")).to eq(true)
        end
      end
    end
  end

  describe 'state mutation' do
    before do
      instance.import!(
        hand_main: { state: :ok },
        hand_off: { state: :ok }
      )
      expect(instance.hand_main.ok?).to eq true
      expect(instance.hand_off.ok?).to eq true
    end

    describe '#maim!' do
      it 'maims target anatomy' do
        instance.hand_main.maim!
        expect(instance.hand_main.ok?).to eq(false)
        expect(instance.hand_main!).to eq(:maimed)
      end
    end

    describe '#sunder!' do
      it 'sunders target anatomy' do
        instance.hand_main.sunder!
        expect(instance.hand_main.ok?).to eq(false)
        expect(instance.hand_main!).to eq(:sundered)
      end
    end

    describe '#pristine!' do
      describe 'from sundered state' do
        before { instance.hand_main.sunder! }

        it 'returns anatomy to ok state' do
          instance.hand_main.pristine!
          expect(instance.hand_main.ok?).to eq(true)
          expect(instance.hand_main!).to eq(:ok)
        end
      end

      describe 'from maimed state' do
        before { instance.hand_main.maim! }

        it 'returns anatomy to ok state' do
          instance.hand_main.pristine!
          expect(instance.hand_main.ok?).to eq(true)
          expect(instance.hand_main!).to eq(:ok)
        end
      end

      describe 'from ok state' do
        before { instance.hand_main.pristine! }

        it 'stills be in ok state' do
          instance.hand_main.pristine!
          expect(instance.hand_main.ok?).to eq(true)
          expect(instance.hand_main!).to eq(:ok)
        end
      end

      describe 'when anatomy is not available' do
        it 'raises error' do
          expect do
            instance.head.pristine!
          end.to raise_error(Concerns::Anatomiable::AnatomyNotAvailable)
        end
      end
    end

    describe '#repair!' do
      describe 'from sundered state' do
        before { instance.hand_main.sunder! }

        it 'returns anatomy to maimed state' do
          instance.hand_main.repair!
          expect(instance.hand_main.ok?).to eq(false)
          expect(instance.hand_main!).to eq(:maimed)
        end
      end

      describe 'from maimed state' do
        before { instance.hand_main.maim! }

        it 'returns anatomy to ok state' do
          instance.hand_main.repair!
          expect(instance.hand_main.ok?).to eq(true)
          expect(instance.hand_main!).to eq(:ok)
        end
      end

      describe 'from ok state' do
        before { instance.hand_main.pristine! }

        it 'sunders target anatomy' do
          instance.hand_main.repair!
          expect(instance.hand_main.ok?).to eq(true)
          expect(instance.hand_main!).to eq(:ok)
        end
      end

      describe 'when anatomy is not available' do
        it 'does not affect target anatomy' do
          expect do
            instance.head.repair!
          end.to raise_error(Concerns::Anatomiable::AnatomyNotAvailable)
        end
      end
    end
  end

  context 'with complex content' do
    let(:input) do
      {
        hand_main: { props: %i[sword steel], weight: 20, state: :ok },
        hand_off: { props: %i[shield wooden], weight: 18, state: :ok },
        arm_main: { state: :ok },
        slingback: {
          props: %i[slingback leather],
          weight: 1,
          state: :ok,
          contents: [
            { props: %i[arrow iron], weight: 0.1 },
            { props: %i[arrow iron], weight: 0.1 },
            { props: %i[arrow iron], weight: 0.1 },
            { props: %i[arrow iron], weight: 0.1 }
          ]
        }
      }
    end

    before { instance.import!(input) }

    it 'stores object properties correctly' do
      expect(instance.hand_main.available?).to eq true
      expect(instance.hand_main.equippable?).to eq false
      expect(instance.hand_main.sword?).to eq true
      expect(instance.hand_main.steel?).to eq true
      expect(instance.hand_main.throwable?).to eq false
      expect(instance.hand_main.weight).to eq input[:hand_main][:weight]
      expect(instance.arm_main.available?).to eq true
      expect(instance.arm_main.equippable?).to eq true
      expect(instance.arm_off.available?).to eq false
    end

    it 'allows weight adjustment' do
      instance.hand_main.weight = 32
      expect(instance.hand_main.weight).to eq 32

      instance[:hand_main][:weight] = 64
      expect(instance.hand_main.weight).to eq 64
    end

    context 'with queryable' do
      describe '#holding' do
        it 'returns anatomy object holding requested properties' do
          expect(instance.holding(:sword).keys).to contain_exactly(:hand_main)
          expect(instance.holding(:steel, :leather).keys).to contain_exactly(:hand_main, :slingback)
        end

        describe 'result' do
          let(:query) { instance.holding(:steel, :leather) }

          it 'is manipulatable' do
            query.each { |_k, v| v.weight *= 2 }
            query.each do |k, _v|
              expect(instance.send(k).weight).to eq(input[k][:weight] * 2)
            end
          end
        end
      end
    end

    context 'with weaponizable' do
      describe '#disarm!' do
        it 'disarms target' do
          disarmed = instance.hand_main.disarm!
          expect(instance.hand_main.available?).to eq true
          expect(instance.hand_main.equippable?).to eq true
          expect(disarmed).to eq(input[:hand_main].except(:state))
        end
      end
    end
  end
end
