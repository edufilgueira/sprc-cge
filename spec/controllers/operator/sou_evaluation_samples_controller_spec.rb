require 'rails_helper'

RSpec.describe Operator::SouEvaluationSamplesController, type: :controller do
	setup do
		sign_in(user)
	end

	let(:user) { create(:user, :operator_cge) }
	let(:ticket_parent) {create(:ticket)}
	let(:ticket) {create(:ticket, :replied, :with_organ, parent_id: ticket_parent.id )}
	let(:sou_evaluation_sample_params) { filtered_params }

		
  it { is_expected.to be_kind_of(Operator::SouEvaluationSamples::Breadcrumbs) }
	
  it '#create' do
  	expect do
      post(:create, params: sou_evaluation_sample_params)
      is_expected.to respond_with(:found)
    end.to change(Operator::SouEvaluationSample, :count).by(1)
  end

  it 'create samples details' do
  	expect do
      post(:create, params: sou_evaluation_sample_params)
      is_expected.to respond_with(:found)
    end.to change(Operator::SouEvaluationSampleDetail, :count).by(1)
  end
end

def filtered_params
	{ 
		title:'Teste Felipe Local',
		sample_ids: ticket_parent.id,
		filtered_params: "{
			\"organ\"=>\"#{ticket.organ_id}\",
			\"topic\"=>\"\", 
			\"sou_type\"=>\"\", 
			\"answer_type\"=>\"\", 
			\"percentage\"=>\"30\", 
			\"start\"=>\"01/05/2020\", 
			\"end\"=>\"05/05/2020\"
		}"
	}
end