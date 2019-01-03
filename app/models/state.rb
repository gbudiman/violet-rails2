# frozen_string_literal: true

class State
  attr_reader :stats,
              :resources,
              :skills,
              :effects,
              :anatomies,
              :equipments,
              :inventories

  def initialize(h)
    @stats = {}.extend(Concerns::Statable).import!(h[:stats])
    @resources = {}.extend(Concerns::Resourceable).import!(h[:resources])
    @skills = h[:skills]
    @effects = h[:effects].extend(Concerns::Effectable).import!(h[:effects])
    @anatomies = {}.extend(Concerns::Anatomiable).import!(h[:anatomies])
  end
end
