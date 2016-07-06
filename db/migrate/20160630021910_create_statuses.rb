class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.integer :state
      t.string :description
      t.references :solution, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
