class CreateVideoSelectors < ActiveRecord::Migration
  def change
    create_table :video_selectors do |t|
      t.boolean :default_selection
      t.integer :track
      t.integer :input_id
      t.integer :video_id
      
      t.timestamps null: false
    end
  end
end
