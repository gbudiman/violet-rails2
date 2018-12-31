require 'rails_helper'

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
        hp: { current: 500 },
        limit: { current: 8 },
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
  it { expect(subject.stats).to be_a_kind_of(State::Stat) }
  it 'expects stats to be initialized correctly' do
    stats = subject.stats
    [:str, :agi, :dex, :int, :vit, :fai, :limit, :trance, :orb, 
     :impulse, :malice, :mana, :soul, :gestalt, :prayer].each do |key|
      expect(stats.send(key)).to eq(state[:stats][key] || 0)
      expect(stats.send("#{key}_base")).to eq(state[:stats][key] || 0)
      expect(stats.send("#{key}_aux")).to eq(0)
    end
  end
end
