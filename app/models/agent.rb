# frozen_string_literal: true

class Agent < ApplicationRecord
  include Violet

  belongs_to :battlefield
  after_initialize :copy_initial_state, :generate_uuid
  after_find :load_state
  after_commit :load_state, on: %i[create update]

  delegate :anatomies, to: :workable_state
  delegate :effects, to: :workable_state
  delegate :resources, to: :workable_state
  delegate :skills, to: :workable_state
  delegate :stats, to: :workable_state

  def self.register!(battlefield_id:, state:)
    Agent.create!(battlefield_id: battlefield_id, initial_state: state)
  end

  def derive_secondary_stats!
    Violet::MODULES.each do |mod|
      submodules_of(mod).each do |submod|
        class_of(mod, submod).new(@workable_state)
      end
    end
  end

  private

  attr_accessor :workable_state

  def copy_initial_state
    self.current_state = initial_state
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def load_state
    @workable_state = State.new(current_state.deep_symbolize_keys)
  end
end
