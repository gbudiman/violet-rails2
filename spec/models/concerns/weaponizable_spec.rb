# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Concerns::Weaponizable, type: :model do
  # class Subject
  #   include Concerns::Weaponizable
  # end

  # let(:state) do
  #   {
  #     anatomy: {
  #       hand_main: :ok,
  #       hand_off: :ok,
  #       arm_main: :ok,
  #       arm_off: :ok,
  #       foot_main: :ok,
  #       foot_off: :ok,
  #       head: :ok,
  #       torso: :ok,
  #       hip: :ok,
  #     },
  #     equipments: {
  #       hand_main: { props: [:sword] },
  #       hand_off: { props: [:shield] },
  #     },
  #   }
  # end

  # subject { State.new(state) }

  # context "with both functioning limbs" do
  #   it { expect(subject.equipments.hand_main.status).to eq :equipped }
  # end

  # context "with main hand broken" do
  #   it "should drop weapon" do
  #     state.anatomy.hand_main = :maimed
  #     expect(subject.equipments.hand_main.status).to eq :unequippable
  #     expect(subject.equipments.hand_off.status).to eq :equipped
  #   end
  # end

  # context "with off hand broken" do
  #   it "should drop shield" do
  #     state.anatomy.hand_off = :sundered
  #     expect(subject.equipments.hand_main.status).to eq :equipped
  #     expect(subject.equipments.hand_off.status).to eq :unequippable
  #   end
  # end
end
