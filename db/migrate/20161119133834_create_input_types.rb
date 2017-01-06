class CreateInputTypes < ActiveRecord::Migration
  def change
    create_table :input_types do |t|
      t.string :type_name

      t.timestamps null: false
    end
  end
end
