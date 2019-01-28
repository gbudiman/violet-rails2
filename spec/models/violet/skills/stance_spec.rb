# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a skill with prerequisites' do
  def assign_subject(subject_skill)
    skill_container.send("#{subject_skill}=", true)
  end

  def assign_prerequisites(preq_skills)
    Array.wrap(preq_skills).each do |preq_skill|
      skill_container.send("#{preq_skill}=", true)
    end
  end

  describe 'prerequisites' do
    
    it 'enables skills with fulfilled prerequisites' do
      skills_under_test.each do |skill, preqs|
        assign_prerequisites(preqs)
        assign_subject(skill)
        #ap skill_container
        expect(skill_container.all?(*[skill, preqs].flatten)).to eq(true)
      end
    end
  end
  

  # it 'rejects skills '
end

RSpec.describe Violet::Skills::Stance do
  subject(:skills) { {}.extend(Concerns::Skillable) }

  # describe 'prerequisites' do
  #   before do
  #     skills.stance_vigilance = true
  #   end

  #   it 'enables skill with fulfilled prerequisites' do
  #     skills.stance_vigilance_keen_eyes = true
  #     expect(skills.all?(:stance_vigilance, :stance_vigilance_keen_eyes)).to eq(true)
  #   end

  #   it 'rejects skill with unfulfilled prerequisites' do
  #     expect do
  #       skills.stance_bulwark_bladestorm = true
  #     end.to raise_error do |error|
  #       expect(error).to be_a_kind_of(Concerns::Skillable::MissingSkillPrerequisite)
  #       expect(error.missing).to contain_exactly(:stance_bulwark)
  #     end
  #   end
  # end
  it_behaves_like 'a skill with prerequisites' do
    let(:skill_container) { skills }
    let(:skills_under_test) do 
      {
        stance_vigilance: nil,
        stance_vigilance_keen_eyes: :stance_vigilance,

      }
    end
  end
end
