module Violet
  module Skills
    module Limit
      extend ActiveSupport::Concern

      included do
        def compute_derived_stat
          if skills.has_all?(:limit_break_mechanics, :limit_break_redux)
            resources.limit.max = stats.limit * 3 / 4
          end
        end
      end
    end
  end
end