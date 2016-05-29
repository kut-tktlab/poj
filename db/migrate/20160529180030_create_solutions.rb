class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :source, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end
