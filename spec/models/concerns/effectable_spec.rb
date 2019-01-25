# frozen_string_literal: true

require 'rails_helper'

module EffectTestable
  def self.extended(_base)
    %i[permanent_effect active_effect active_duration expired_effect expired_duration].each do |key|
      define_method("#{key}=") do |h|
        self[key] = define_effect(h).extend(Concerns::EffectQueryable)
      end
    end
  end
end

RSpec.describe Concerns::Effectable, type: :model do
  subject(:instance) do
    {}.extend(Concerns::Effectable, EffectTestable)
  end

  before do
    instance.permanent_effect = { stack: :permanent }
    instance.active_effect = { stack: 3 }
    instance.active_duration = { duration: 10 }
    instance.expired_effect = { stack: 0 }
    instance.expired_duration = { duration: 0 }
  end

  it 'lists #actives and #inactives correctly' do
    active_effects = %i[permanent_effect active_effect active_duration]
    inactive_effects = %i[expired_effect expired_duration]
    expect(instance.actives.keys).to contain_exactly(*active_effects)
    expect(instance.inactives.keys).to contain_exactly(*inactive_effects)

    expect(instance.keys).to contain_exactly(*(active_effects + inactive_effects))
  end
end
