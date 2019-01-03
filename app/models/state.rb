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
    #@resources = Resource.new(h[:resources])
    #@skills = h[:skills]
    #@effects = h[:effects].extend(Concerns::Effectable)
    #@anatomies = {}.extend(Concerns::Anatomiable).import!(h[:anatomies])

    #ap @stats.included_modules
  end
end
