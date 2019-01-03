module Concerns
  module Skillable
    extend ActiveSupport::Concern

    def self.extended(base)
      base.class.include Violet
      base.submodules_of(:skills).each do |school|
        base.class_of(:skills, school)::SKILLS.each do |skill|
          key = "#{school}_#{skill}".to_sym
          define_method("#{school}_#{skill}") do
            self[key]
          end

          define_method("#{school}_#{skill}=") do |value|
            self[key] = value
          end
        end
      end
      # Violet::SKILLS.each do |sk|
      #   ap sk
      #   ap base
      # end
    end
  end
end