module PPA
  module Revision
    module PrioritizationHelper

      def new_prioritization_path
        new_ppa_revision_prioritization_operation_path(
          plan_id: plan.id,
          prioritization_id: prioritization.id
        )
      end
    end
  end
end