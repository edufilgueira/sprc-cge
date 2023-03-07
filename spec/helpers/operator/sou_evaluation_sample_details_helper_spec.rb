require 'rails_helper'

module Operator
	describe SouEvaluationSampleDetailsHelper, type: :helper do

		setup do
			user = create(:user, :operator_cge_denunciation_tracking)

		  @current_user = user
		  @status = "open"
		end
		
		describe '#link_or_read_only_for_denunciantion' do
			context 'user denunciation tracking' do
				it 'when ticket is not denunciation ' do
					ticket = create(:ticket)
					expected = "<a href=\"/operator/tickets/#{ticket.id}?status=open#tabs-internal_evaluation\">#{ticket.protocol}</a>"

					expect(link_or_read_only_for_denunciantion(ticket, ticket.protocol, @status)).to eq(expected)
				end

				it 'when ticket is denunciation' do
					ticket_denunciation = create(:ticket, :denunciation)
					expected = "<a href=\"/operator/tickets/#{ticket_denunciation.id}?status=open#tabs-internal_evaluation\">#{ticket_denunciation.protocol}</a>"

					expect(link_or_read_only_for_denunciantion(ticket_denunciation, ticket_denunciation.protocol, @status)).to eq(expected)
				end
			end

			context 'user is not denunciation tracking' do
				before { current_user.denunciation_tracking = false }

				it 'when ticket is not denunciation ' do
					ticket = create(:ticket)
					expected = "<a href=\"/operator/tickets/#{ticket.id}?status=open#tabs-internal_evaluation\">#{ticket.protocol}</a>"

					expect(link_or_read_only_for_denunciantion(ticket, ticket.protocol, @status)).to eq(expected)
				end

				it 'when ticket is denunciation' do
					ticket = create(:ticket, :denunciation)
					expected = ticket.protocol

					expect(link_or_read_only_for_denunciantion(ticket, ticket.protocol, @status)).to eq(expected)
				end
			end
		end
	end
end

def current_user
  @current_user
end