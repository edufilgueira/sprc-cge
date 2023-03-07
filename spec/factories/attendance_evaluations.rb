FactoryBot.define do
	factory :attendance_evaluation do
		clarity   5
		content   5
		wording   5
		kindness  5
		comment		'My string'
		classification 	nil
		quality 	nil
		treatment 	nil
		textual_structure 	nil

		trait :sou_categories do
			textual_structure 5
			treatment 5
			quality 5
			classification 5
		end

		trait :with_ticket_sou do
			association :ticket, factory: [:ticket, :confirmed, :with_parent]
		end
	end
end
