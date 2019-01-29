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

    def smart_import!(list)
      unresolved_stack = []
      iteration_count = {}

      worklist = list.dup
      loop do

        Array.wrap(worklist).each do |element|
          ap "trying to append #{element}"
          import_if_possible(element)

          if prerequisite_satisfied?(element)
            ap "adding #{element} if not exist..."
            self.send("#{element}=", true) unless has?(element)
          else
            ap "Unable to resolve #{element} yet..."
            unresolved_stack |= Array.wrap(element)
          end
        end

        break if unresolved_stack.blank?
        worklist = unresolved_stack.dup
        unresolved_stack = []
        ap "Current unresolved stack is"
        ap worklist
      end
    end

    def import_if_possible(skill)
      prerequisites = Concerns::Stateable.preqs[skill]
      if has?(skill)
        ap "already has #{skill}, moving on..."
      elsif prerequisite_satisfied?(skill)
        ap "preqs satisfied for #{skill}, adding..."
        self.send("#{skill}=", true)
        ap self
      elsif prerequisites.blank?
        ap "no preqs for #{skill}, adding..."
        self.send("#{skill}=", true)
        ap self
      else
        ap "recursive strategy for #{skill}..."
        prerequisites.each do |preq|
          import_if_possible(preq)
        end
      end
    end

    def prerequisite_satisfied?(key)
      return true if Concerns::Stateable::preqs[key].nil?
      return true if self.all?(*Concerns::Stateable::preqs[key])
      false
    end

    def validate_prerequisites!(key)
      raise MissingSkillPrerequisite, 
        list_missing_prerequisites(key) unless prerequisite_satisfied?(key)
    end

    def list_missing_prerequisites(key)
      all = Concerns::Stateable::preqs[key]
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
