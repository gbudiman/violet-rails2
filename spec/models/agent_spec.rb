# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agent, type: :model do
  let(:state) do
    {
      stat: {
        str: 30,
        agi: 50,
        dex: 26,
        int:  1,
        vit: 77,
        fai: 16
      },
      skills: {},
      effects: {},
      equipments: {},
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
      expect(agent.stat.str).to be_a_kind_of(Integer)
    end
  end
end
