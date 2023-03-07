module Operator
  module SouEvaluationSamples::BaseController
    extend ActiveSupport::Concern

    def filtered_tickets_finalized(scope)
      scope.where(internal_status: Ticket.internal_statuses[:final_answer])
    end

    def sample_ids
      @scope.pluck(:id) if params[:organ].present?
    end

    def operator_tickets
      current_user.operator_accessible_tickets.where(marked_internal_evaluation: false)
    end

    def register_ticket_log(ticket)
      RegisterTicketLog.call(
        ticket, 
        current_user_or_ticket, :create_sou_evaluation_sample, 
        { 
          resource_type: controller_name.camelize, 
          resource_id: ticket.id,
          data: create_data_log_attributes
        }
      )
    end

    def next_code
      sample_last = Operator::SouEvaluationSample.last

      # code recebe 1 para tratar a base sem registros
      code = sample_last.nil? ? 1 : sample_last.code.next
    end

    def redirect_to_list_samples_with_success
      set_success_flash_notice
      redirect_to operator_generated_lists_path
    end

    def set_success_flash_notice
      flash[:notice] = t(".#{ticket.ticket_type}.done", title: resource_notice_title)
    end

    def retrieve_tickets_samples_by_ids
      organ_id = find_organ_id
      
      ticket_parent_ids = params['sample_ids'].gsub(' ',', ')

      Ticket.where("parent_id IN(#{ticket_parent_ids}) AND organ_id = #{organ_id}")
    end

    def calculate_limit(scope_size)
      if scope_size > 0
        ((scope_size * params[:percentage].to_i) / 100).round
      end
    end

    def filtered_count
      filtered_tickets.count
    end

    def filtered_samples_count
      filtered_samples.count
    end

    def total_samples_count
      scope_default.count
    end

    def find_organ_id
      params['filtered_params']['organ'].to_i
    end

    def create_data_log_attributes
      {
        responsible_user_id: current_user.id,
        responsible_organ_id: child.organ_id,
        responsible_subnet_id: child.subnet_id
      }
    end

    
    private

    def sou_evaluation_sample_params_hash
      {  
        code: next_code,
        status: Operator::SouEvaluationSample.statuses[:open],
        created_by_id: current_user.id,
        filters: params[:filtered_params],
        title: params[:title]
      }
    end

    def sou_evaluation_sample_details_params_hash(ticket)
      {  
        sou_evaluation_sample: last_sou_evaluation_sample,
        ticket: ticket #filho
      }
    end

    def last_sou_evaluation_sample
      Operator::SouEvaluationSample.last
    end

  end
end