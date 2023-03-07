module PPA
  module Admin
    module Revision
      module ExportsHelper

        def ppa_plan_revising
          @plan ||= PPA::Plan.find_by_start_year(2020)
        end
                
      end
    end
  end
end