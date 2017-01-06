class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.integer :live_event_id
      t.string :input_label
      t.boolean :loop_source
      t.integer :input_type
      t.boolean :quad
      t.string :uri

      t.timestamps null: false
    end
  end
end
