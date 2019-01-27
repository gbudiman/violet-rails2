# frozen_string_literal: true

class State
  attr_reader :stats,
              :resources,
              :skills,
              :effects,
              :anatomies

  def initialize(hsh)
    @stats = {}.extend(Concerns::Statable).import!(hsh[:stats])
    @resources = {}.extend(Concerns::Resourceable).import!(hsh[:resources])
    @skills = {}.extend(Concerns::Skillable).import!(hsh[:skills])
    @effects = {}.extend(Concerns::Effectable).import!(hsh[:effects])
    @anatomies = {}.extend(Concerns::Anatomiable).import!(hsh[:anatomies])
  end

  def push_effect(**kwargs)
    arg = caller_locations(1, 1)[0].label.split(/\s/).last.to_sym
    effect = @effects.send(arg)

    begin
      if effect.nil?
        @effects.send("#{arg}=", kwargs)
      else
        effect << kwargs
      end
    rescue Concerns::EffectQueryable::IncompatibleQualifier => e
      raise Concerns::EffectQueryable::IncompatibleQualifier, "Pushing effect #{arg}: #{e.message}"
    end
  end
end
