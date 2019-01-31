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

    class UnresolvedSkillImport < StandardError
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

    def smart_import!(list) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      unresolved_skills = []

      loop do
        changes_made = 0
        subchanges_made = false

        Array.wrap(list).each do |element|
          unresolved_skills.delete(element)
          next if has?(element)

          if prerequisite_satisfied?(element)
            changes_made += 1
            self << element
          else
            Concerns::Stateable.preqs[element].each do |preq|
              if preq.in?(Array.wrap(list)) && prerequisite_satisfied?(preq)
                subchanges_made = true
                self << preq
              else
                unresolved_skills << preq
              end
            end

            unresolved_skills << element
          end
        end

        break if (!subchanges_made && changes_made.zero?) || (Array.wrap(list).length == changes_made)
      end

      return unless (Array.wrap(list) - keys).length.positive?

      raise UnresolvedSkillImport, "Unresolved skills #{unresolved_skills} while importing #{list}"
    end

    def <<(other)
      send("#{other}=", true)
    end

    def prerequisite_satisfied?(key)
      return true if Concerns::Stateable.preqs[key].nil?
      return true if all?(*Concerns::Stateable.preqs[key])

      false
    end

    def validate_prerequisites!(key)
      return if prerequisite_satisfied?(key)

      raise MissingSkillPrerequisite, list_missing_prerequisites(key)
    end

    def list_missing_prerequisites(key)
      all = deep_prerequisites(key)
      {
        skill: key,
        all: all,
        missing: all.reject { |preq| has?(preq) }
      }
    end

    def deep_prerequisites(key)
      y = (Concerns::Stateable.preqs[key] || []).map do |preq|
        deep_prerequisites(preq)
      end

      (Array.wrap(y) + Array.wrap(key)).flatten.uniq
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
