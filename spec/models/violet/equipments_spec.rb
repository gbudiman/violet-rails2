# frozen_string_literal: true

require "rails_helper"

RSpec.describe Violet::Equipments, type: :model do
  class Dummy
    include Violet::Equipments
    attr_accessor :state
    delegate_missing_to :state

    def initialize(state)
      @state = state
    end
  end

  let(:state) do
    RecursiveOpenStruct.new(
      equipments: {
        hand_main: { props: [:sword, :disarmable] },
        hand_off: { props: [:shield, :disarmable] },
      },
    )
  end

  subject(:dummy) { Dummy.new(state) }

  context "#anatomies_holding" do
    it "should return matching anatomies" do
      expect(dummy.anatomies_holding(:shield)).to contain_exactly(:hand_off)
      expect(dummy.anatomies_holding(:disarmable)).to contain_exactly(:hand_main, :hand_off)
    end
  end
end
