# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::Anatomiable, type: :concern do
  subject { {}.extend(Concerns::Anatomiable) }

  context "#import!" do
    it "should load anatomies from Hash correctly" do
      [:ok, :maimed, :sundered].each do |state|
        input = { hand_main: state, hand_off: state }
        subject.import!(input)
        expect(subject.keys).to contain_exactly(*input.keys)
      end
    end

    it "should raise error on invalid anatomy" do
      expect do
        subject.import!(invalid_limb: :ok)
      end.to raise_error(Concerns::Anatomiable::InvalidAnatomy, /^Invalid Anatomy: invalid_limb/)
    end

    it "should raise error on invalid anatomy state" do
      expect do
        subject.import!(hand_main: :invalid)
      end.to raise_error(Concerns::Anatomiable::InvalidState, /^Invalid State: invalid on Anatomy: hand_main/)
    end
  end

  it "should be method-accessible" do
    Concerns::Anatomiable::VALID_ANATOMIES.each do  |anatomy|
      expect(subject.send("#{anatomy}!")).to eq(:not_available)
    end
  end

  context "state mutation" do
    before do
      subject.import!(hand_main: :ok, hand_off: :ok)
      expect(subject.hand_main.ok?).to eq true
      expect(subject.hand_off.ok?).to eq true
    end

    context "#maim!" do
      it "should maim target anatomy" do
        subject.hand_main.maim!
        expect(subject.hand_main.ok?).to eq(false)
        expect(subject.hand_main!).to eq(:maimed)
      end
    end

    context "#sunder!" do
      it "should sunder target anatomy" do
        subject.hand_main.sunder!
        expect(subject.hand_main.ok?).to eq(false)
        expect(subject.hand_main!).to eq(:sundered)
      end
    end

    context "#pristine!" do
      context "from sundered state" do
        before { subject.hand_main.sunder! }
        it "should return anatomy to ok state" do
          subject.hand_main.pristine!
          expect(subject.hand_main.ok?).to eq(true)
          expect(subject.hand_main!).to eq(:ok)
        end
      end

      context "from maimed state" do
        before { subject.hand_main.maim! }
        it "should return anatomy to ok state" do
          subject.hand_main.pristine!
          expect(subject.hand_main.ok?).to eq(true)
          expect(subject.hand_main!).to eq(:ok)
        end
      end

      context "from ok state" do
        before { subject.hand_main.pristine! }
        it "should still be in ok state" do
          subject.hand_main.pristine!
          expect(subject.hand_main.ok?).to eq(true)
          expect(subject.hand_main!).to eq(:ok)
        end
      end

      context "when anatomy is not available" do
        it "should not affect target anatomy" do
          subject.head.pristine!
          expect(subject.head!).to eq(:not_available)
        end
      end
    end

    context "#repair!" do
      context "from sundered state" do
        before { subject.hand_main.sunder! }
        it "should return anatomy to maimed state" do
          subject.hand_main.repair!
          expect(subject.hand_main.ok?).to eq(false)
          expect(subject.hand_main!).to eq(:maimed)
        end
      end

      context "from maimed state" do
        before { subject.hand_main.maim! }
        it "should return anatomy to ok state" do
          subject.hand_main.repair!
          expect(subject.hand_main.ok?).to eq(true)
          expect(subject.hand_main!).to eq(:ok)
        end
      end

      context "from ok state" do
        before { subject.hand_main.pristine! }
        it "should sunder target anatomy" do
          subject.hand_main.repair!
          expect(subject.hand_main.ok?).to eq(true)
          expect(subject.hand_main!).to eq(:ok)
        end
      end

      context "when anatomy is not available" do
        it "should not affect target anatomy" do
          subject.head.repair!
          expect(subject.head!).to eq(:not_available)
        end
      end
    end
  end
end
