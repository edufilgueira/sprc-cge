FactoryBot.define do
	factory :sou_evaluation_sample_detail, class: 'Operator::SouEvaluationSampleDetail' do
		association :ticket, factory: [:ticket, :with_parent]
		association :sou_evaluation_sample, factory: [:sou_evaluation_sample]
		rated false

		trait :with_rated do
			rated true
		end 
	end
end
