# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a skill with prerequisites' do
  def assign_subject(list)
    skill_container.smart_import!(list)
  end

  def prepend_skill_names(klass, hsh)
    hsh.transform_keys! { |key| "#{klass}_#{key}".to_sym }
    hsh.transform_values! do |val|
      case val
      when ->(v) { v.is_a?(Array) }
        val.map { |x| "#{klass}_#{x}".to_sym }
      when ->(v) { v.is_a?(Symbol) }
        "#{klass}_#{val}".to_sym
      end
    end
  end

  before do
    klass = described_class.name.demodulize.downcase
    prepend_skill_names(klass, skills_under_test)
    prepend_skill_names(klass, invalid_skills)
  end

  it 'enables skills with fulfilled prerequisites' do
    skills_under_test.each do |skill, preqs|
      skill_container.clear
      assign_subject(preqs)
      assign_subject(skill)
      expect(skill_container).to(
        include(*(Array.wrap(skill) + Array.wrap(preqs)).uniq.compact),
        -> { skill_container.list_missing_prerequisites(skill) }
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
        vigilance: nil,
        bulwark: :vigilance,
        colossus: :vigilance,
        recovery: :vigilance,
        mobility: %i[bulwark vigilance],
        aggression: %i[colossus vigilance],
        focus: %i[recovery vigilance],
        phalanx: %i[mobility aggression focus bulwark colossus recovery vigilance],
        vigilance_keen_eyes: :vigilance,
        bulwark_bladestorm: %i[bulwark vigilance],
        colossus_deadlock: %i[colossus vigilance],
        aggression_shield_durability: %i[aggression colossus vigilance],
        aggression_quicken: %i[aggression colossus vigilance],
        aggression_continuum: %i[aggression colossus vigilance],
        recovery_deft_block: %i[recovery vigilance],
        phalanx_extension: %i[phalanx mobility aggression focus bulwark colossus recovery vigilance],
        phalanx_gap: %i[phalanx_extension phalanx mobility aggression focus bulwark colossus recovery vigilance],
        phalanx_polearm: %i[phalanx_extension phalanx_gap phalanx
                            mobility aggression focus bulwark colossus recovery vigilance]
      }
    end
    let(:invalid_skills) do
      {
        phalanx: %i[mobility aggression focus]
      }
    end
  end

  context 'with state' do
    subject(:instance) { State.new({}) }

    describe 'stance_activation' do
      before do
        instance.effects.stance_vigilance = { stack: :permanent }
        instance.skills.smart_import!(described_class.active_stances)
      end

      described_class.active_stances.each do |stance|
        it "only activates effect of stance #{stance}" do
        end
      end
    end
  end
end
