# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :model do
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

  let(:bf) { Battlefield.create! }

  it 'is registered to a battlefield correctly' do
    expect do
      Agent.register!(battlefield_id: bf.id, state: state)
    end.to change(Agent, :count).by 1
  end

  describe 'fetching' do
    let(:agent) { Agent.register!(battlefield_id: bf.id, state: state) }

    it 'automaticallies convert current_state to OpenStruct' do
      expect(Agent.find(agent.id).stats.str!).to be_a_kind_of(Integer)
    end

    describe 'preprocessing' do
      before do
        agent.derive_secondary_stats!
      end

      describe 'secondary stats' do
        it 'is derived correctly' do
          expect(agent.resources.weight.capacity).to be_a_kind_of(Float)
          expect(agent.resources.weight!).to eq(29)
        end
      end

      describe 'equipment checks' do
        it 'indicates equipped status correctly' do
          expect(agent.anatomies.hand_main.sword?).to eq(true)
          expect(agent.anatomies.hand_off.shield?).to eq(true)
        end
      end

      describe 'effect checks' do
        it 'adds effect from skills correctly' do
          anatomies = state[:anatomies]
          expect(agent.effects.shield_slinger.stack).to eq(:permanent)
          expect(agent.effects.actives).to include(:shield_slinger)
          expect(agent.resources.weight!).to eq(
            anatomies[:hand_main][:weight] + anatomies[:hand_off][:weight] / 2
          )
        end
      end
    end
  end
end
