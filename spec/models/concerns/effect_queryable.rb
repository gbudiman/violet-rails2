require "rails_helper"

RSpec.describe Concerns::EffectQueryable, type: :concern do
  subject { {}.extend(Concerns::EffectQueryable) }

  it 'should initialize effect properly' do
    subject.dummy_effect = { stack: :permanent }
    expect(subject.dummy_effect.active?).to eq true
  end
end