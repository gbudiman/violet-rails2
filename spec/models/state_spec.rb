# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  subject(:instance) { State.new(state) }

  let(:state) do
    {
      stats: {
        str: 32,
        agi: 50,
        dex: 26,
        int: 1,
        vit: 77,
        fai: 16,
        limit: 32
      },
      resources: {
        hp: 500,
        limit: 8
      },
      skills: {
        limit_mechanics: true,
        limit_redux: true,
        limit_steel_lung: true,
        shield_slinger: true
      },
      effects: {
        stance_vigilance: { stack: :permanent }
      },
      anatomies: {
        hand_main: { state: :ok, props: [:sword], weight: 20 },
        hand_off: { state: :ok, props: [:shield], weight: 18 },
        arm_main: { state: :ok },
        arm_off: { state: :ok },
        foot_main: { state: :ok },
        foot_off: { state: :ok },
        head: { state: :ok },
        torso: { state: :ok },
        hip: { state: :ok },
        slingback: { state: :ok }
      }
    }
  end

  let(:stats) { instance.stats }
  let(:resources) { instance.resources }
  let(:effects) { instance.effects }
  let(:skills) { instance.skills }
  let(:anatomies) { instance.anatomies }

  it { expect(instance.stats).to be_a_kind_of(Hash) }
  it 'expects stats to be initialized correctly' do
    %i[str agi dex int vit fai limit trance orb
       impulse malice mana soul gestalt prayer].each do |key|
      expect(stats.send("#{key}!")).to eq(state[:stats][key] || 0)
      expect(stats.send(key).send(:base)).to eq(state[:stats][key] || 0)
      expect(stats.send(key).send(:aux)).to eq(0)
    end
  end
  it 'expects stats auxiliary to be get/set correctly' do
    stats.str.visceral_strength = 32
    expect(stats.str!).to eq(stats.str.visceral_strength + state[:stats][:str])
    expect(stats.str.base).to eq(state[:stats][:str])
    expect(stats.str.aux).to eq(stats.str.visceral_strength)
    expect(stats.str.auxes).to eq(
      visceral_strength: stats.str.visceral_strength
    )
  end
  it 'expects resources to be initialized correctly' do
    %i[hp weight limit trance orb
       impulse malice mana soul gestalt prayer].each do |key|
      expect(resources.send("#{key}!")).to eq(state[:resources][key] || 0)
      expect(resources.send(key).send(:current)).to eq(state[:resources][key] || 0)

      random_number = 2000
      resources.send(key).capacity = random_number
      expect(resources.send(key).send(:capacity)).to eq(random_number)
    end
  end

  describe 'skills' do
    it 'is correctly queryable' do
      expect(skills.has?(:shield_slinger)).to eq true
      expect(skills.has?(:random_dne)).to eq false
    end
  end

  describe 'effects' do
    it 'includes pre-imported effects' do
      expect(effects.stance_vigilance.active?).to eq true
    end

    it 'is correctly accessible' do
      effects.shield_slinger = { stack: :permanent }
      expect(effects.shield_slinger.active?).to eq true
    end

    describe 're-entrancy' do
      before do
        effects.shield_slinger = { stack: :permanent }
      end

      it 'appends new effect correctly' do
        expect(instance.effects.shield_slinger).to receive(:<<).and_call_original
        Violet::Skills::Shield.new(instance)
      end
    end
  end

  describe 'anatomies' do
    it 'is correctly available' do
      expect(anatomies.foot_main.ok?).to eq true
    end

    it 'raises error on invalid anatomy' do
      expect { anatomies.random_limb }.to raise_error(Concerns::Anatomiable::InvalidAnatomy)
    end
  end
end
