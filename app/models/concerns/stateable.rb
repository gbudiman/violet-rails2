# frozen_string_literal: true

module Concerns
  module Stateable
    extend ActiveSupport::Concern
    mattr_accessor :preqs do
      {}
    end

    included do
      attr_accessor :state
      delegate_missing_to :state
    end

    class_methods do # rubocop:disable Metrics/BlockLength
      def prerequisites_for(skill, prerequisites)
        Concerns::Stateable.preqs[skill] ||= []
        Concerns::Stateable.preqs[skill] += Array.wrap(prerequisites)
      end

      def prerequisites_map(input_hash)
        klass = caller_locations(1, 1)[0].label.split(/:/).last.match(/(\w+)/)[1]
        valid_skills = "Violet::Skills::#{klass}".constantize::SKILLS

        hsh = prepend_skill_names(klass.downcase, input_hash.dup)
        validate_skills!(klass, hsh, valid_skills)
        hsh.each { |skill, preqs| prerequisites_for(skill, preqs) }
      end

      def prepend_skill_names(klass, hsh)
        hsh.transform_keys! { |key| "#{klass}_#{key}".to_sym }
        hsh.transform_values! do |val|
          if val.is_a?(Array)
            val.map { |x| "#{klass}_#{x}".to_sym }
          else
            "#{klass}_#{val}".to_sym
          end
        end
      end

      def validate_skills!(klass, hsh, valid_skills)
        invalids = hsh.map do |skill, preqs|
          ([skill] + Array.wrap(preqs)).reject { |x| x.in?(valid_skills) }
        end.reduce([]) { |a, b| a + b }.uniq.compact # rubocop:disable Style/MultilineBlockChain

        return unless invalids.present?

        raise Violet::Skills::InvalidSkillName, "Invalid prerequisites_map for #{klass}: #{invalids}"
      end
    end

    def initialize(state)
      @state = state
    end
  end
end
