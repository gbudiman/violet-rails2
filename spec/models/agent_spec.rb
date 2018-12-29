# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agent, type: :model do
  let(:state) { {} }
  before do
    @bf = Battlefield.create!
  end

  it "should be registered to a battlefield correctly" do
    expect do
      Agent.register!(battlefield_id: @bf.id, state: state)
    end.to change { Agent.count }.by 1
  end
end
