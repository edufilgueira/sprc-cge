class CreatePPAMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_metrics do |t|
      t.string     :type,       null: false
      t.references :mensurable, polymorphic: true, index: true
      t.decimal    :planned,    precision: 8, scale: 2, default: 0.0
      t.decimal    :realized,   precision: 8, scale: 2, default: 0.0
      t.integer    :year
      t.integer    :period
      t.text       :options

      t.timestamps
    end

  end
end
