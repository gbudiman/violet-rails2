require 'rails_helper'

RSpec.describe Violet::Skills::Stance do
  subject(:skills) {{}.extend(Concerns::Skillable)}

  describe 'prerequisites' do
    before do
      skills.stance_vigilance = true
    end

    it 'enables skill with fulfilled prerequisites' do
      skills.stance_vigilance_keen_eyes = true
      expect(skills.all?(:stance_vigilance, :stance_vigilance_keen_eyes)).to eq(true)
    end

    it 'rejects skill with unfulfilled prerequisites' do
      expect do
        skills.stance_bulwark_bladestorm = true
      end.to raise_error do |error|
        expect(error).to be_a_kind_of(Concerns::Skillable::MissingSkillPrerequisite)
        expect(error.missing).to contain_exactly(:stance_bulwark)
      end
    end
  end
end