# frozen_string_literal: true

require "rails_helper"

RSpec.describe State, type: :model do
  let(:state) do
    {
      stats: {
        str: 32,
        agi: 50,
        dex: 26,
        int:  1,
        vit: 77,
        fai: 16,
        limit: 32,
      },
      resources: {
        hp: 500,
        limit: 8,
      },
      skills: {
        limit_break_mechanics: true,
        limit_break_redux: true,
        limit_break_steel_lung: true,
        shield_slinger: true,
      },
      effects: {},
      anatomies: {
        hand_main: :ok,
        hand_off: :ok,
        arm_main: :ok,
        arm_off: :ok,
        feet: :ok,
        head: :ok,
        torso: :ok,
        hip: :ok,
      },
      equipments: {
        hand_main: { props: [:sword], weight: 20 },
        hand_off: { props: [:shield], weight: 18 },
      },
      inventories: {},
    }
  end

  subject { State.new(state) }
  let(:stats) { subject.stats }
  let(:resources) { subject.resources }
  let(:effects) { subject.effects }
  it { expect(subject.stats).to be_a_kind_of(State::Stat) }
  it "expects stats to be initialized correctly" do
    [:str, :agi, :dex, :int, :vit, :fai, :limit, :trance, :orb,
     :impulse, :malice, :mana, :soul, :gestalt, :prayer].each do |key|
      expect(stats.send("#{key}!")).to eq(state[:stats][key] || 0)
      expect(stats.send(key).send(:base)).to eq(state[:stats][key] || 0)
      expect(stats.send(key).send(:aux)).to eq(0)
    end
  end
  it "expects stats auxiliary to be get/set correctly" do
    stats.str.visceral_strength = 32
    expect(stats.str!).to eq(stats.str.visceral_strength + state[:stats][:str])
    expect(stats.str.base).to eq(state[:stats][:str])
    expect(stats.str.aux).to eq(stats.str.visceral_strength)
    expect(stats.str.auxes).to eq(
      visceral_strength: stats.str.visceral_strength
    )
  end
  it "expects resources to be initialized correctly" do
    [:hp, :weight, :limit, :trance, :orb,
     :impulse, :malice, :mana, :soul, :gestalt, :prayer].each do |key|
      expect(resources.send("#{key}!")).to eq(state[:resources][key] || 0)
      expect(resources.send(key).send(:current)).to eq(state[:resources][key] || 0)

      random_number = 2000
      resources.send(key).capacity = random_number
      expect(resources.send(key).send(:capacity)).to eq(random_number)
    end
  end

  context "effects" do
    it 'should be correctly accessible' do
      effects.shield_slinger = { stack: :permanent }
      ap effects
      ap effects.shield_slinger
      ap effects.shield_slinger.active?
    end
  end
end
