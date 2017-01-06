class CreateLiveEvents < ActiveRecord::Migration
  def change
    create_table :live_events do |t|
      t.string :name
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
