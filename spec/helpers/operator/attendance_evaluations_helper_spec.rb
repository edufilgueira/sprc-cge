require 'rails_helper'
# include TicketsHelper

module Operator
	describe AttendanceEvaluationsHelper, type: :helper do
		setup do
    	@organ = create(:organ)
    	@resource = create(:sou_evaluation_sample, filters: {organ: @organ.id})
  	end

		describe '#weight_per_ticket_type' do
			it 'ticket_type is sic'do 
				ticket_type = 'sic'
				expect(weight_per_ticket_type(ticket_type)).to eq(AttendanceEvaluation::EVALUATION_WEIGHTS)
			end

			it 'ticket_type is sou'do 
				ticket_type = 'sou'
				expect(weight_per_ticket_type(ticket_type)).to eq(AttendanceEvaluation::EVALUATION_WEIGHTS_SOU)
			end
		end

		describe '#default_constant' do
			it 'AttendanceEvaluation::EVALUATION_WEIGHTS' do
				expected = 'AttendanceEvaluation::EVALUATION_WEIGHTS'
				expect(default_constant).to eq(expected)
			end
		end

		describe '#find_organ' do
			it 'find organ filtered' do
				expected = @organ
				expect(find_organ).to eq(expected)
			end
		end
				
	end
end