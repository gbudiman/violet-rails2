require "rails_helper"

RSpec.describe Concerns::Anatomiable, type: :concern do
  subject { {}.extend(Concerns::Anatomiable) }

  context "#import!" do
    it "should load anatomies from Hash correctly" do
      input = { hand_main: :ok, hand_off: :ok }
      subject.import!(input)
      expect(subject.keys).to contain_exactly(*input.keys)
    end

    it "should raise error on invalid anatomy" do
      expect do
        subject.import!({ invalid_limb: :ok })
      end.to raise_error(Concerns::Anatomiable::InvalidAnatomy, /^Invalid Anatomy: invalid_limb/)
    end
  end
end