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

  it 'enables skills with fulfilled prerequisites' do
    skills_under_test.each do |skill, preqs|
      assign_prerequisites(preqs)
      assign_subject(skill)
      expect(skill_container.all?(*[skill, preqs].flatten)).to eq(true)
    end
  end

  it 'rejects skills with unfulfilled prerequisites' do
    skills_under_test.each do |skill, preqs|
      next if preqs.nil?
      expect { assign_subject(skill) }.to raise_error do |error|
        expect(error).to be_a_kind_of(Concerns::Skillable::MissingSkillPrerequisite)
        expect(error.missing).to contain_exactly(*preqs)
      end
    end
  end
end

RSpec.describe Violet::Skills::Stance do
  subject(:skills) { {}.extend(Concerns::Skillable) }

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
