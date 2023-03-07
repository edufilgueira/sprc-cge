require 'rails_helper'

RSpec.describe Operator::SouEvaluationSamples::GeneratedListsController, type: :controller do
	
	
	let(:user) { create(:user, :operator_cge) }
	let(:ticket_parent) { create(:ticket) }
	let(:ticket) { create(:ticket, :replied, :with_organ, parent_id: ticket_parent.id ) }
	let(:sample_detail) { create(:sou_evaluation_sample_detail) }
	let(:sample) { sample_detail.sou_evaluation_sample }

	describe 'destroy' do
		before {
			
			sample_detail

			sign_in(user)
		}


		describe 'Without Attedance Evaluation' do
			it 'sample and details and ticket changes' do
				delete(:destroy, params: { id: sample.id })
				
				expect(sample.reload.deleted_at).not_to be_nil
				expect(sample_detail.reload.deleted_at).not_to be_nil
				expect(sample_detail.reload.deleted_at).not_to be_nil
				expect(response).to be_a_redirect
				is_expected.to set_flash.to(I18n.t('.operator.sou_evaluation_samples.destroy.sou.done'))
				is_expected.to redirect_to(operator_generated_lists_path)
			end
		end 

		describe 'With Attedance Evaluation' do
			it 'sample and details and ticket changes' do
				evaluation = create(:attendance_evaluation, :sou_categories, ticket_id: sample_detail.ticket.id )

				delete(:destroy, params: { id: sample.id })
				
				expect(sample.reload.deleted_at).not_to be_nil
				expect(sample_detail.reload.deleted_at).not_to be_nil
				expect(sample_detail.reload.deleted_at).not_to be_nil
				expect(response).to be_a_redirect
				is_expected.to set_flash.to(I18n.t('.operator.sou_evaluation_samples.destroy.sou.done'))
				is_expected.to redirect_to(operator_generated_lists_path)
				expect(evaluation.reload.deleted_at).not_to be_nil
			end
		end 

	end
end