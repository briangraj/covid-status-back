class CreateUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :updates do |t|
      t.date :last_load_date
      t.integer :updated_records

      t.timestamps
    end
  end
end
