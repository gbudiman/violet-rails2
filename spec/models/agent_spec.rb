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
        hp: 1000,
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
      anatomy: {
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
      expect(agent.stats.str).to be_a_kind_of(Integer)
    end

    context "preprocessing" do
      before do
        @agent.derive_secondary_stats!
      end

      context "secondary stats" do
        it "should be derived correctly" do
          expect(@agent.resources.limit.max).to eq 24
          expect(@agent.resources.weight.max).to be_a_kind_of(Float)
        end
      end

      context "equipment checks" do
        it "should indicate equipped status correctly" do
          [:hand_main, :hand_off].each do |limb|
            expect(@agent.equipments[limb].status).to eq(:equipped)
          end
        end
      end

      context "effect checks" do
        it "should add effect from skills correctly" do
          expect(@agent.effects.shield_slinger.stack).to eq(:permanent)
          expect(@agent.resources.weight.current).to eq(29)
        end
      end
    end
  end
end
