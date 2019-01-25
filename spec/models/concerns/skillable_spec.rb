# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Concerns::Skillable, type: :model do
  subject(:instance) { {}.extend(Concerns::Skillable) }

  it 'initializes skill properly' do
    instance.limit_redux = true
    expect(instance.send('limit_redux!')).to eq true
  end

  it 'returns the skill availability state' do
    instance.limit_mechanics = true
    expect(instance.limit_mechanics?).to eq true
    expect(instance.limit_redux?).to eq false
  end

  describe 'querying' do
    before do
      instance.all!(true, :limit_mechanics, :limit_redux)
    end

    it 'invokes MultiQueryable methods correctly' do
      expect(instance.all?(:limit_mechanics, :limit_redux)).to eq(true)
      expect(instance.all?(:limit_mechanics, :limit_redux, :limit_steel_lung)).to eq(false)
      expect(instance.all?(:limit_mechanics)).to eq(true)
      expect(instance.all?(:limit_steel_lung, :limit_redux)).to eq(false)
      expect(instance.one?(:limit_mechanics)).to eq(true)
      expect(instance.one?(:limit_mechanics, :limit_redux)).to eq(true)
      expect(instance.one?(:limit_mechanics, :limit_redux, :limit_steel_lung)).to eq(true)
      expect(instance.one?(:limit_steel_lung)).to eq(false)
    end
  end

  describe 'temporary disabler' do
    before do
      instance.limit_redux = true
      expect(instance.has?(:limit_redux)).to eq true
    end

    it 'allows temporarily disabling skills' do
      instance.disable!(:limit_redux)
      expect(instance.has?(:limit_redux)).to eq false
      expect(instance.has?(:limit_redux, any_state: true)).to eq true

      instance.enable!(:limit_redux)
      expect(instance.has?(:limit_redux)).to eq true
      expect(instance.has?(:limit_redux, any_state: true)).to eq true
    end

    it 'does not re-enable non-existing skill' do
      expect(instance.has?(:limit_steel_lung)).to eq false
      instance.enable!(:limit_steel_lung)
      expect(instance.has?(:limit_steel_lung)).to eq false
      expect(instance.has?(:limit_steel_lung, any_state: true)).to eq false
    end
  end
end
