# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a skill with prerequisites' do
  def assign_subject(list)
    skill_container.smart_import!(list)
  end

  it 'enables skills with fulfilled prerequisites' do
    skills_under_test.each do |skill, preqs|
      skill_container.clear
      assign_subject(preqs)
      assign_subject(skill)
      expect(skill_container).to(
        include(*(Array.wrap(skill) + Array.wrap(preqs)).uniq.compact),
        lambda { skill_container.list_missing_prerequisites(skill) }
      )
    end
  end

  it 'rejects skills with unfulfilled prerequisites' do
    invalid_skills.each do |skill, missing_preqs|
      skill_container.clear
      expect { skill_container << skill }.to raise_error do |error|
        expect(error).to be_a(Concerns::Skillable::MissingSkillPrerequisite)
        expect(error.missing).to include(*missing_preqs)
      end
    end
  end
end

RSpec.describe Violet::Skills::Stance do
  it_behaves_like 'a skill with prerequisites' do
    let(:skill_container) { {}.extend(Concerns::Skillable) }
    let(:skills_under_test) do 
      {
        stance_vigilance: nil,
        stance_vigilance_keen_eyes: :stance_vigilance,
        stance_bulwark: :stance_vigilance,
        stance_bulwark_bladestorm: %i[stance_bulwark stance_vigilance],
      }
    end
    let(:invalid_skills) do
      {
        stance_phalanx: %i[stance_mobility stance_aggression stance_focus]
      }
    end
  end
end
