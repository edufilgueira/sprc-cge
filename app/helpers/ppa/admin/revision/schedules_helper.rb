module PPA
  module Admin
    module Revision
      module SchedulesHelper

        def stages_for_select
          stages_keys.map do |stage|
          	[stage_title(stage), stage]
          end
        end

        def stages_keys
          PPA::Revision::Schedule.stages.keys
        end

        def stage_title(stage)
          I18n.t("ppa.admin.revision.schedules.stages.#{stage}")
        end 
        
      end
    end
  end
end


