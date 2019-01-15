# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::Equippable, type: :model do
  subject { {}.extend(Concerns::Equippable) }

  context "assignment" do
    let(:input) do
      {
        hand_main: { props: [:sword, :steel], weight: 20 },
        hand_off: { props: [:shield, :wooden], weight: 18 },
        arm_main: {},
        slingback: { 
          props: [:slingback, :leather],
          weight: 1,
          contents: [
            { props: [:arrow, :iron], weight: 0.1 },
            { props: [:arrow, :iron], weight: 0.1 },
            { props: [:arrow, :iron], weight: 0.1 },
            { props: [:arrow, :iron], weight: 0.1 },
          ]
        }
      }
    end

    before { subject.import!(input) }

    it "stores object properties correctly" do
      expect(subject.hand_main.available?).to eq true
      expect(subject.hand_main.equippable?).to eq false
      expect(subject.hand_main.sword?).to eq true
      expect(subject.hand_main.steel?).to eq true
      expect(subject.hand_main.throwable?).to eq false
      expect(subject.hand_main.weight).to eq input[:hand_main][:weight]
      expect(subject.arm_main.available?).to eq true
      expect(subject.arm_main.equippable?).to eq true
      expect(subject.arm_off.available?).to eq false
      expect(subject.arm_off.equippable?).to eq false
    end

    it "allows weight adjustment" do
      subject.hand_main.weight = 32
      expect(subject.hand_main.weight).to eq 32

      subject[:hand_main][:weight] = 64
      expect(subject.hand_main.weight).to eq 64
    end

    context "query" do
      context "#holding" do
        it "returns anatomy object holding requested properties" do
          expect(subject.holding(:sword).keys).to contain_exactly(:hand_main)
          expect(subject.holding(:steel, :leather).keys).to contain_exactly(:hand_main, :slingback)
        end
      end
    end

    context "weaponizable" do
      context "#disarm!" do
        it "disarms target" do
          disarmed = subject.hand_main.disarm!
          expect(subject.hand_main.available?).to eq true
          expect(subject.hand_main.equippable?).to eq true
          expect(disarmed).to eq(input[:hand_main])
        end
      end

      context "#maim" do
        it "maims target" do
          subject.hand_main.maim!
          expect(subject.hand_main.maimed?).to eq(true)
          expect(subject.hand_main.available?).to eq(true)
          expect(subject.hand_main.equippable?).to eq(false)
          expect(subject.hand_main.usable?).to eq(false)
          expect(subject.hand_main.holding_something?).to eq(true)
        end
      end

      context "#sunder" do
        it "sunders target" do
          subject.hand_main.sunder!
          expect(subject.hand_main.sundered?).to eq(true)
          expect(subject.hand_main.available?).to eq(true)
          expect(subject.hand_main.equippable?).to eq(false)
          expect(subject.hand_main.usable?).to eq(false)
          expect(subject.hand_main.holding_something?).to eq(false)
        end
      end

      context "#drop!" do
        pending
      end

      context "#holster!" do
        pending
      end
      
      context "#equip" do
        pending
      end
    end
  end
end
