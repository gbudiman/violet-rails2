# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agent, type: :model do
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
        limit_mechanics: true,
        limit_redux: true,
        limit_steel_lung: true,
        shield_slinger: true,
      },
      effects: {},
      anatomies: {
        hand_main: :ok,
        hand_off: :ok,
        arm_main: :ok,
        arm_off: :ok,
        foot_main: :ok,
        foot_off: :ok,
        head: :ok,
        torso: :ok,
        hip: :ok,
        slingback: :ok
      },
      equipments: {
        hand_main: { props: [:sword], weight: 20 },
        hand_off: { props: [:shield], weight: 18 },
      },
    }
  end

  before do
    @bf = Battlefield.create!
  end

  it "should be registered to a battlefield correctly" do
    expect do
      Agent.register!(battlefield_id: @bf.id, state: state)
    end.to change { Agent.count }.by 1
  end

  context "fetching" do
    before do
      @agent = Agent.register!(battlefield_id: @bf.id, state: state)
    end

    it "should automatically convert current_state to OpenStruct" do
      agent = Agent.find(@agent.id)
      expect(agent.stats.str!).to be_a_kind_of(Integer)
    end

    context "preprocessing" do
      before do
        @agent.derive_secondary_stats!
      end

      context "secondary stats" do
        it "is derived correctly" do
          expect(@agent.resources.weight.capacity).to be_a_kind_of(Float)
          expect(@agent.resources.weight!).to eq(29)
        end
      end

      context "equipment checks" do
        it "should indicate equipped status correctly" do
          expect(@agent.equipments.hand_main.sword?).to eq(true)
          expect(@agent.equipments.hand_off.shield?).to eq(true)
        end
      end

      context "effect checks" do
        it "should add effect from skills correctly" do
          equipped = state[:equipments]
          expect(@agent.effects.shield_slinger.stack).to eq(:permanent)
          expect(@agent.effects.actives).to include(:shield_slinger)
          expect(@agent.resources.weight!).to eq(
            equipped[:hand_main][:weight] + equipped[:hand_off][:weight] / 2
          )
          #expect(@agent.effects.shield_slinger.stack).to eq(:permanent)
          #expect(@agent.resources.weight.current).to eq(
          #  equipped[:hand_main][:weight] + equipped[:hand_off][:weight] / 2
          #)
        end
      end
    end
  end
end
