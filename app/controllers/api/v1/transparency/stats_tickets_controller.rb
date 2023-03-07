class Api::V1::Transparency::StatsTicketsController < Api::V1::ApplicationController

  def status
    render json: json_status
  end

  private

  def json_status
    Stats::Ticket.find(params['id']).to_json(only: [:status])
  end
end
