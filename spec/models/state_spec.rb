# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  subject { State.new(state) }

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
      effects: {},
      anatomies: {
        hand_main: :ok,
        hand_off: :ok,
        arm_main: :ok,
        arm_off: :ok,
        foot_main: :ok,
        foot_off: :ok,
        torso: :ok,
        hip: :ok,
        slingback: :ok
      },
      equipments: {
        hand_main: { props: [:sword], weight: 20 },
        hand_off: { props: [:shield], weight: 18 }
      }
    }
  end

  let(:stats) { subject.stats }
  let(:resources) { subject.resources }
  let(:effects) { subject.effects }
  let(:skills) { subject.skills }
  let(:anatomies) { subject.anatomies }

  it { expect(subject.stats).to be_a_kind_of(Hash) }
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

  context 'skills' do
    it 'is correctly queryable' do
      expect(skills.has?(:shield_slinger)).to eq true
      expect(skills.has?(:random_dne)).to eq false
    end
  end

  context 'effects' do
    it 'is correctly accessible' do
      effects.shield_slinger = { stack: :permanent }
      expect(effects.shield_slinger.active?).to eq true
    end

    context 're-entrancy' do
      before do
        effects.shield_slinger = { stack: :permanent }
      end

      it 'appends new effect correctly' do
        expect(subject.effects.shield_slinger).to receive(:<<).and_call_original
        Violet::Skills::Shield.new(subject)
      end
    end
  end

  context 'anatomies' do
    it 'is correctly available' do
      expect(anatomies.foot_main.ok?).to eq true
    end

    it 'raises error on invalid anatomy' do
      expect { anatomies.random_limb }.to raise_error(Concerns::Anatomiable::InvalidAnatomy)
    end
  end
end
