class State::Stat
  VALID_ATTRIBUTES = [:str, :agi, :dex, :int, :vit, :fai, :limit, :trance, :orb, :impulse, :malice, :mana, :soul, :gestalt, :prayer]

  def initialize(**kwargs)
    VALID_ATTRIBUTES.each do |key|
      instance_variable_set("@#{key}", { base: kwargs[key] || 0 })
    end
  end

  VALID_ATTRIBUTES.each do |key|
    define_method(key) { 
      instance_variable_get("@#{key}")[:base]
    }
  end
end