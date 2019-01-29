# frozen_string_literal: true

module Concerns
  module Skillable
    class MissingSkillPrerequisite < StandardError
      attr_reader :skill, :all, :missing, :has

      def initialize(hsh)
        @skill = hsh[:skill]
        @all = hsh[:all]
        @missing = hsh[:missing]
        @has = @all - @missing

        super
      end
    end

    extend ActiveSupport::Concern

    def self.extended(base)
      base.class.include Violet
      base.class.include Concerns::MultiQueryable
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school)::SKILLS.each do |skill|
          key = skill.to_sym
          define_method(key) { ExtensionProxy.new(self, key) }
          define_method("#{key}=") do |value|
            validate_prerequisites!(key)
            self[key] = value
          end
          define_method("#{key}?") { self[key] == true }
          define_method("#{key}!") { self[key] || false }
        end
      end
    end

    def validate_prerequisites!(key)
      return if Concerns::Stateable.preqs[key].nil?
      return if all?(*Concerns::Stateable.preqs[key])

      raise MissingSkillPrerequisite, list_missing_prerequisites(key)
    end

    def list_missing_prerequisites(key)
      all = Concerns::Stateable.preqs[key]
      {
        skill: key,
        all: all,
        missing: all.reject { |preq| has?(preq) }
      }
    end

    def import!(hsh)
      hsh.each do |k, v|
        self[k] = v
      end

      self
    end

    def has?(skill, any_state: false)
      return false unless key?(skill)

      proxied_skill = send(skill.to_s)
      (proxied_skill.available? || (any_state && proxied_skill.disabled?)) == true
    end

    def set!(state, *skills)
      skills.flatten.each do |skill|
        send(skill).set!(state) if has?(skill, any_state: true)
      end
    end

    def disable!(*skills)
      set!(:disabled, skills)
    end

    def enable!(*skills)
      set!(true, skills)
    end
  end

  class ExtensionProxy < BaseProxy
    def disabled?
      @field_accessor == :disabled
    end

    def available?
      @field_accessor == true
    end

    def set!(val)
      @ancestor.send("#{@attribute}=", val)
    end
  end
end
