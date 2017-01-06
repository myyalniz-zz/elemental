class CreateAudioSelectors < ActiveRecord::Migration
  def change
    create_table :audio_selectors do |t|
      t.boolean :default_selection
      t.integer :track
      t.integer :input_id
      t.integer :audio_id

      t.timestamps null: false
    end
  end
end
