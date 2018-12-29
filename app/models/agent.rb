# frozen_string_literal: true

class Agent < ApplicationRecord
  belongs_to :battlefield
  after_initialize :copy_initial_state, :generate_uuid

  def self.register!(battlefield_id:, state:)
    Agent.create!(battlefield_id: battlefield_id, initial_state: :state)
  end

private

  def copy_initial_state
    self.current_state = self.initial_state
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
