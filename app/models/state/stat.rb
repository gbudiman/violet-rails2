class State::Stat
  VALID_ATTRIBUTES = [:str, :agi, :dex, :int, :vit, :fai, :limit, :trance, :orb, :impulse, :malice, :mana, :soul, :gestalt, :prayer]

  def initialize(**kwargs)
    VALID_ATTRIBUTES.each do |key|
      instance_variable_set("@#{key}", { base: kwargs[key] || 0 })
    end
  end

  VALID_ATTRIBUTES.each do |key|
    define_method(key) do
      instance_variable_get("@#{key}").map{ |k, v| v }.reduce(0, :+)
    end

    define_method("#{key}_base") do
      instance_variable_get("@#{key}")[:base]
    end

    define_method("#{key}_aux") do
      instance_variable_get("@#{key}").reject{ |k, v| k == :base }.reduce(0, :+)
    end
  end
end