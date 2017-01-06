class CreateInputProcessings < ActiveRecord::Migration
  def change
    create_table :input_processings do |t|
      t.integer :event_id
      t.integer :input_id

      t.timestamps null: false
    end
  end
end
