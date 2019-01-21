# frozen_string_literal: true

class State
  attr_reader :stats,
              :resources,
              :skills,
              :effects,
              :anatomies,
              :equipments

  def initialize(h)
    @stats = {}.extend(Concerns::Statable).import!(h[:stats])
    @resources = {}.extend(Concerns::Resourceable).import!(h[:resources])
    @skills = {}.extend(Concerns::Skillable).import!(h[:skills])
    @effects = {}.extend(Concerns::Effectable).import!(h[:effects])
    @anatomies = {}.extend(Concerns::Anatomiable).import!(h[:anatomies])
    @equipments = {}.extend(Concerns::Equippable).import!(h[:equipments])
  end

  def push_effect(**kwargs)
    @effects.push(caller_locations(1, 1)[0].label.split(/\s/).last, kwargs)
  end
end
