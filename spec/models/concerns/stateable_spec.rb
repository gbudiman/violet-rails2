# frozen_string_literal: true

require 'rails_helper'

class StateTestable
  SKILLS = %i[first_skill].freeze

  include Concerns::Stateable
end

RSpec.describe State, type: :model do
  let(:stubbed_caller_location) do
    [
      OpenStruct.new(label: 'class:StateTestable')
    ]
  end

  describe '#validate_skills!' do
    it 'is raises error on invalid skill name' do
      expect do
        StateTestable.validate_skills!(
          StateTestable,
          { first_skill: :second_skill },
          StateTestable::SKILLS
        )
      end.to raise_error(Violet::Skills::InvalidSkillName, /second_skill/)
    end
  end
end
