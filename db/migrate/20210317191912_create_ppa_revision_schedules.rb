class CreatePPARevisionSchedules < ActiveRecord::Migration[5.0]
	def change
		create_table :ppa_revision_schedules do |t|

			t.date     'start_in', null: false
			t.date     'end_in',   null: false
			t.integer  'plan_id',  null: false, index: true
			t.integer  'stage',    null: false

			t.timestamps
		end

		add_foreign_key :ppa_revision_schedules, :ppa_plans, column: :plan_id
	end
end
