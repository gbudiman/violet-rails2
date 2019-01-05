module Concerns
  module Skillable
    extend ActiveSupport::Concern

    def self.extended(base)
      base.class.include Violet
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school)::SKILLS.each do |skill|
          key = skill.to_sym

          define_method(key) do
            ExtensionProxy.new(self, key)
          end

          define_method("#{key}=") do |value|
            self[key] = value
          end

          define_method("#{key}?") do
            self[key] == true
          end

          define_method("#{key}!") do
            self[key] || false
          end
        end
      end
    end

    def import!(h)
      h.each do |k, v|
        self[k] = v
      end
    end

    def has?(skill, any_state: false)
      proxied_skill = self.send("#{skill}")
      if any_state
        (proxied_skill.available? || proxied_skill.disabled?) == true
      else
        #self.send("#{skill}!") == true
        proxied_skill.available? == true
      end
    end

    def set!(state, *skills)
      skills.flatten.each do |skill|
        if has?(skill, any_state: true)
          self.send(skill).set!(state)
        end
      end
    end

    def disable!(*skills)
      set!(:disabled, skills)
    end

    def enable!(*skills)
      set!(true, skills)
    end
  end

  class ExtensionProxy
    def initialize(ancestor, attribute)
      @ancestor = ancestor
      @attribute = attribute
      @target = @ancestor[@attribute]
    end

    def disabled?
      @target == :disabled
    end

    def available?
      @target == true
    end

    def set!(val)
      @ancestor.send("#{@attribute}=", val)
    end
  end
end
