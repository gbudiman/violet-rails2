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
      }
    end

    before { subject.import!(input) }

    it "should store object properties correctly" do
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

    it "should allow weight adjustment" do
      subject.hand_main.weight = 32
      expect(subject.hand_main.weight).to eq 32

      subject[:hand_main][:weight] = 64
      expect(subject.hand_main.weight).to eq 64
    end

    context "weaponizable" do
      context "#disarm!" do
        it "should disarm target" do
          disarmed = subject.hand_main.disarm!
          expect(subject.hand_main.available?).to eq true
          expect(subject.hand_main.equippable?).to eq true
          expect(disarmed).to eq(input[:hand_main])
        end
      end

      context "#maim" do
        it "should main target" do
          subject.hand_main.maim!
          expect(subject.hand_main.maimed?).to eq(true)
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
