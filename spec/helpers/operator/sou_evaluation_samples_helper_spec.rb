require 'rails_helper'
include TicketsHelper

module Operator
	describe SouEvaluationSamplesHelper, type: :helper do
		
		describe 'Constants' do
			context 'filters params' do 
				it 	'OTHERS_SAMPLES_FILTERS_PARAMS' do
					expected = [
						:code,
						:status, 
						:title
					]

					expect(Operator::SouEvaluationSamplesHelper::OTHERS_SAMPLES_FILTERS_PARAMS).to eq(expected)
				end
			end
		end

		describe '#samples_all_status' do
			it 'status list' do
				keys = Operator::SouEvaluationSample.statuses.keys

				expected =
					keys.map do |status|
						[ I18n.t("operator.sou_evaluation_samples.generated_lists.index.filters.status.#{status}"), status ]
					end

				expect(samples_all_status).to eq(expected)
			end
		end

		describe '#details_sample_count'	do
			it 'count' do
				sou_evaluation_sample = create(:sou_evaluation_sample)

				10.times.each do
					create(:sou_evaluation_sample_detail, sou_evaluation_sample: sou_evaluation_sample)
				end
			
				expect(details_sample_count(sou_evaluation_sample)).to eq(Operator::SouEvaluationSampleDetail.count)
			end
		end

		describe '#percentage_evaluated'	do
			it 'percentage of rated' do
				sou_evaluation_sample = create(:sou_evaluation_sample)

				4.times.each do
					create(:sou_evaluation_sample_detail, :with_rated, sou_evaluation_sample: sou_evaluation_sample)
				end

				6.times.each do
					create(:sou_evaluation_sample_detail, sou_evaluation_sample: sou_evaluation_sample)
				end
			
				expect(percentage_evaluated(sou_evaluation_sample)).to eq(40.0)
			end
		end

		describe '#find_user' do
			it 'search user by id' do
				user = create(:user)

				expect(find_user(user.id)).to eq(user)
			end
		end

		describe '#define_submit' do
			let(:controller_name) { :sou_evaluation_samples }

			it 'when controller name is sou_evaluation_sample' do
				set_controller_name(controller_name)

				expect(define_submit).to eq(I18n.t('commands.define_sample'))
			end
		end

		describe '#trait_params' do
			it 'when controller name is sou_evaluation_sample' do
				parameters = ActionController::Parameters.new(
					params_hash_attributes
				)

				expected = params_hash_attributes
				expected['start'] = params_hash_attributes['confirmed_at']['start']
				expected['end'] = params_hash_attributes['confirmed_at']['end']
				expected = expected.without('confirmed_at')
				expect(trait_params(parameters)).to eq(expected)
			end
		end

		describe '#exclude_non_filterable' do
			it 'when exist params non filterable' do
				parameters = ActionController::Parameters.new(
					params_hash_attributes
				)	

				expected = params_hash_attributes.without(
					'utf8',
					'ticket_type',
					'locale',
					'controller',
					'action',
					'sort_column',
					'sort_direction',
					'page',
					'commit'
				)

				expect(exclude_non_filterable(parameters)).to eq(expected)
			end
		end

		describe '#samples_filter_params' do
			context 'parameter' do 
				it 'when is range created_at' do
					params = { created_at: { start: Time.now() -1.month, end: Time.now() -1.day } }

					expect(samples_filter_params?(params)).to be_truthy
				end

				it 'when is other filters' do
					params = { code: 1, status: 1, title: 'My title' }

					expect(samples_filter_params?(params)).to be_truthy
				end

				it 'when is not range created_at and is not other filters' do
					params = { organ: 14 }

					expect(samples_filter_params?(params)).to be_falsey
				end
			end
		end
	end
end


def set_controller_name(controller_name)
	TicketsHelper.class_eval do
		define_method :controller_name_sou_evaluation_samples? do
			controller_name == :sou_evaluation_samples
		end
	end
end

def params_hash_attributes
	{'utf8'=>'✓',
		'ticket_type'=>'sou',
		'sort_column'=>'',
		'sort_direction'=>'',
		'page'=>'',
		'locale'=>'pt-BR',
		'confirmed_at'=>{
			'start'=>'04/05/2021',
			'end'=>'26/04/2021'
		}, 
		'organ'=>'14',
		'topic'=>'',
		'sou_type'=>'',
		'answer_type'=>'',
		'percentage'=>'',
		'controller'=>'operator/sou_evaluation_samples',
		'action'=>'index'
	}
end