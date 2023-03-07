class RemoveNameDescriptionOrganIdProtocolToSouEvaluationSample < ActiveRecord::Migration[5.0]
  def change
     remove_column :sou_evaluation_samples, :name, :string
     remove_column :sou_evaluation_samples, :description, :string
     remove_column :sou_evaluation_samples, :organ_id, :integer
     remove_column :sou_evaluation_samples, :protocol, :integer
  end
end