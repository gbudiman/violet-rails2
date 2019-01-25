# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battlefield, type: :model do
  before do
    @bf = Battlefield.new
  end

  it 'is created with random seed' do
    expect { @bf.save! }.to change(Battlefield, :count).by 1
    expect(@bf.seed).not_to be nil
  end
end
