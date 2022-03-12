class CreateCases < ActiveRecord::Migration[7.0]
  def change
    create_table :cases do |t|
      t.integer :event_id
      t.string :gender
      t.integer :age
      t.string :state
      t.date :diagnosis_date
      t.date :death_date

      t.timestamps
    end
  end
end
