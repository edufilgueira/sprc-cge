FactoryBot.define do
	factory :ticket_protect_attachment do
		association :resource, factory: [:ticket]
		attachment
	end
end