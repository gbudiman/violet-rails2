# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Concerns::Equippable, type: :model do
  subject(:instance) { {}.extend(Concerns::Equippable) }

  describe 'assignment' do
    let(:input) do
      {
        hand_main: { props: %i[sword steel], weight: 20 },
        hand_off: { props: %i[shield wooden], weight: 18 },
        arm_main: {},
        slingback: {
          props: %i[slingback leather],
          weight: 1,
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
      expect(instance.arm_off.equippable?).to eq false
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
          expect(disarmed).to eq(input[:hand_main])
        end
      end

      describe '#maim' do
        it 'maims target' do
          instance.hand_main.maim!
          expect(instance.hand_main.maimed?).to eq(true)
          expect(instance.hand_main.available?).to eq(true)
          expect(instance.hand_main.equippable?).to eq(false)
          expect(instance.hand_main.usable?).to eq(false)
          expect(instance.hand_main.holding_something?).to eq(true)
        end
      end

      describe '#sunder' do
        it 'sunders target' do
          instance.hand_main.sunder!
          expect(instance.hand_main.sundered?).to eq(true)
          expect(instance.hand_main.available?).to eq(true)
          expect(instance.hand_main.equippable?).to eq(false)
          expect(instance.hand_main.usable?).to eq(false)
          expect(instance.hand_main.holding_something?).to eq(false)
        end
      end

      describe '#drop!' do
        pending
      end

      describe '#holster!' do
        pending
      end

      describe '#equip' do
        pending
      end
    end
  end
end
