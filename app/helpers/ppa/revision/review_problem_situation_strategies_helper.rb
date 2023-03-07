module PPA
  module Revision
    module ReviewProblemSituationStrategiesHelper

      def multistep_path(type)
        "/shared/ppa/revision/multistep_forms/steps/#{type}"
      end

      def multistep_revision_path(type)
        "#{multistep_path(:revision)}/#{type}"
      end

      def problem_situation_strategies_base_path
        "ppa/revision/review_problem_situation_strategies"
      end

      # def revision_steps_list
      # 	[ :region, :theme,:revision,:resume,:conclusion ]
      # end

      def multisteps_next_btn
        {
          :name => "next",
          :type => "button",
          :value => t('next'),
          style: 'display: none;'
        }
      end

      def multisteps_next_btn_d_block
        {
          :name => "next",
          :type => "button",
          :value => t('next')          
        }
      end

      def multisteps_previous_btn
        {
          :name => "previous",
          :type => "button",
          :value => t('previous')
        }
      end

      def theme_step_axis_listtab_attr(axis_id)
        {
          "aria-controls" => "axis1",
          "data-toggle" => "list",
          :href => "#list-axis_#{axis_id}",
          :role => "tab",
          'class': [
            'list-group-item',
            'list-group-item-action'
          ]
        }
      end

      def theme_step_theme_listtab_attr(axis_id)
        {
          "aria-labelledby" => "#list-axis_#{axis_id}",
          :role => "tabpanel",
          id: "#{axis_id}",
          'class': [
            'tab-pane',
            'fade',
            'show'
          ]
        }
      end

      def input_name_for_problem_situations(id)
        "#{tag_form_region_themes}[problem_situations_attributes][#{id}]"
      end

      def input_name_for_regional_strategies(id)
        "#{tag_form_region_themes}[regional_strategies_attributes][#{id}]"
      end

      def radio_name_for_problem_situations(id)
        "#{input_name_for_problem_situations(id)}[persist]"
      end

      def radio_name_for_regional_strategies(id)
        "#{tag_form_region_themes}[regional_strategies_attributes][#{id}][persist]"
      end

      def is_edit_region_theme?
        (controller_name == 'region_themes' and action_name == 'edit')
      end

      def url_edit_region_theme
        ppa_revision_review_problem_situation_strategy_region_theme_path(plan_id: plan.id, review_problem_situation_strategy_id: @review_problem_situation_strategy_id, id: @region_theme_id )
      end

      def multifor_url_edit
        if is_edit_region_theme?
          url_edit_region_theme
        else
          ppa_revision_review_problem_situation_strategy_path(plan_id: plan.id)
        end
      end

      def region_theme_id_for_form
        return 0 if !@region_theme_id.present?

        @region_theme_id
      end

      def tag_form_region_themes
        form_name_pss = "ppa_revision_review_problem_situation_strategy"
        form_name_rt = "ppa_revision_review_region_theme"
        table_alias = "[region_themes_attributes][0]"

        if is_edit_region_theme?
          "ppa_revision_review_region_theme"
        else
          "#{form_name_pss}#{table_alias}"
        end
      end

      def button_to_resume(title, review_problem_situation_strategy_id)
        link_to(
          title, 
          ppa_revision_review_problem_situation_strategy_path(
            plan_id: plan.id, 
            id: review_problem_situation_strategy_id
          ), 
          class: 'btn btn-sm float-right col-lg-3'
        ) 
      end

      def button_to_abort(title)
        link_to(
          title, 
          ppa_plan_path(id: plan.id), 
          class: 'btn btn-sm float-right col-lg-3'
        ) 
      end

      def review_problem_situation_strategy_id
        return id if try(:id).present? 
        return @review_problem_situation_strategy_id if @review_problem_situation_strategy_id.present?  
      end

      def theme_has_report?(theme)
        (theme.try(:code).try(:present?) and !(theme.code.in? theme.class.no_report_activities))
      end

      def link_to_theme_report_activity(region, axis, theme)
        return '#' unless theme.present? or axis.present? or region.present?
        url = 'http://appsweb.seplag.ce.gov.br/ppa/relatorio_iniciativas_entregas/execucaodiretrizes'
        "#{url}?eixo=#{axis.code}&tema=#{theme.isn}&regiao=#{region.isn}"
      end
    end
  end
end