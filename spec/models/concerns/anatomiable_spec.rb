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

    it 'raises error on invalid anatomy' do
      expect do
        instance.import!({ invalid_limb: { state: :ok } })
      end.to raise_error(Concerns::Anatomiable::InvalidAnatomy, /^Invalid Anatomy: invalid_limb/)
    end

    it 'raises error on invalid anatomy state' do
      expect do
        instance.import!({ hand_main: { state: :invalid } })
      end.to raise_error(Concerns::Anatomiable::InvalidState, /^Anatomy hand_main: Invalid State invalid/)
    end
  end

  # it 'is method-accessible' do
  #   Concerns::Anatomiable::VALID_ANATOMIES.each do |anatomy|
  #     expect(instance.send("#{anatomy}!")).to eq(:not_available)
  #   end
  # end

  # describe 'state mutation' do
  #   before do
  #     instance.import!(hand_main: :ok, hand_off: :ok)
  #     expect(instance.hand_main.ok?).to eq true
  #     expect(instance.hand_off.ok?).to eq true
  #   end

  #   describe '#maim!' do
  #     it 'maims target anatomy' do
  #       instance.hand_main.maim!
  #       expect(instance.hand_main.ok?).to eq(false)
  #       expect(instance.hand_main!).to eq(:maimed)
  #     end
  #   end

  #   describe '#sunder!' do
  #     it 'sunders target anatomy' do
  #       instance.hand_main.sunder!
  #       expect(instance.hand_main.ok?).to eq(false)
  #       expect(instance.hand_main!).to eq(:sundered)
  #     end
  #   end

  #   describe '#pristine!' do
  #     describe 'from sundered state' do
  #       before { instance.hand_main.sunder! }

  #       it 'returns anatomy to ok state' do
  #         instance.hand_main.pristine!
  #         expect(instance.hand_main.ok?).to eq(true)
  #         expect(instance.hand_main!).to eq(:ok)
  #       end
  #     end

  #     describe 'from maimed state' do
  #       before { instance.hand_main.maim! }

  #       it 'returns anatomy to ok state' do
  #         instance.hand_main.pristine!
  #         expect(instance.hand_main.ok?).to eq(true)
  #         expect(instance.hand_main!).to eq(:ok)
  #       end
  #     end

  #     describe 'from ok state' do
  #       before { instance.hand_main.pristine! }

  #       it 'stills be in ok state' do
  #         instance.hand_main.pristine!
  #         expect(instance.hand_main.ok?).to eq(true)
  #         expect(instance.hand_main!).to eq(:ok)
  #       end
  #     end

  #     describe 'when anatomy is not available' do
  #       it 'does not affect target anatomy' do
  #         instance.head.pristine!
  #         expect(instance.head!).to eq(:not_available)
  #       end
  #     end
  #   end

  #   describe '#repair!' do
  #     describe 'from sundered state' do
  #       before { instance.hand_main.sunder! }

  #       it 'returns anatomy to maimed state' do
  #         instance.hand_main.repair!
  #         expect(instance.hand_main.ok?).to eq(false)
  #         expect(instance.hand_main!).to eq(:maimed)
  #       end
  #     end

  #     describe 'from maimed state' do
  #       before { instance.hand_main.maim! }

  #       it 'returns anatomy to ok state' do
  #         instance.hand_main.repair!
  #         expect(instance.hand_main.ok?).to eq(true)
  #         expect(instance.hand_main!).to eq(:ok)
  #       end
  #     end

  #     describe 'from ok state' do
  #       before { instance.hand_main.pristine! }

  #       it 'sunders target anatomy' do
  #         instance.hand_main.repair!
  #         expect(instance.hand_main.ok?).to eq(true)
  #         expect(instance.hand_main!).to eq(:ok)
  #       end
  #     end

  #     describe 'when anatomy is not available' do
  #       it 'does not affect target anatomy' do
  #         instance.head.repair!
  #         expect(instance.head!).to eq(:not_available)
  #       end
  #     end
  #   end
  # end
end
