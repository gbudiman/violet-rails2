# frozen_string_literal: true

require "rails_helper"

RSpec.describe Concerns::EffectQueryable, type: :concern do
  subject { {}.extend(Concerns::Effectable) }

  before do
    subject.permanent_effect = { stack: :permanent }
    subject.active_effect = { stack: 3 }
    subject.active_duration = { duration: 10 }
    subject.expired_effect = { stack: 0 }
    subject.expired_duration = { duration: 0 }
  end

  it "should list #actives and #inactives correctly" do
    active_effects = [:permanent_effect, :active_effect, :active_duration]
    inactive_effects = [:expired_effect, :expired_duration]
    expect(subject.actives.keys).to contain_exactly(*active_effects)
    expect(subject.inactives.keys).to contain_exactly(*inactive_effects)

    expect(subject.keys).to contain_exactly(*(active_effects + inactive_effects))
  end
end
