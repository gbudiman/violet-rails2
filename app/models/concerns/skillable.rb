module Concerns
  module Skillable
    extend ActiveSupport::Concern

    def self.extended(base)
      base.class.include Violet
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school)::SKILLS.each do |skill|
          key = "#{school}_#{skill}".to_sym
          define_method(key) do
            self[key] || false
          end

          define_method("#{key}=") do |value|
            self[key] = value
          end

          define_method("#{key}?") do
            self[key] == true
          end
        end
      end
    end

    def import!(h)
      h.each do |k, v|
        self[k] = v
      end
    end
  end
end