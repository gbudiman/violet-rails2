# frozen_string_literal: true

class Battlefield < ApplicationRecord
  after_initialize :generate_seed
  has_many :agents, dependent: :destroy
  validates :seed, presence: true

  private

    def generate_seed
      self.seed = Random.new.seed % 2**63
    end
end
