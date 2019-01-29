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

    class_methods do
      def prerequisites_for(skill, prerequisites)
        Concerns::Stateable.preqs[skill] ||= []
        Concerns::Stateable.preqs[skill] += Array.wrap(prerequisites)
      end

      def prerequisites_map(hsh)
        klass = caller_locations(1, 1)[0].label.split(/:/).last.match(/(\w+)/)[1]
        valid_skills = "Violet::Skills::#{klass}".constantize::SKILLS
        
        validate_skills!(hsh, valid_skills)
        hsh.each { |skill, preqs| prerequisites_for(skill, preqs) }
      end

      def validate_skills!(hsh, valid_skills)
        invalids = hsh.map do |skill, preqs|
          ([skill] + Array.wrap(preqs)).select{ |x| !x.in?(valid_skills)}
        end.reduce([]) { |a, b| a + b }.uniq.compact

        raise Violet::Skills::InvalidSkillName,
          "Invalid skills detected while setting prerequisites_map for #{klass}: #{invalids}" if invalids.present?
      end
    end

    def initialize(state)
      @state = state
    end
  end
end
