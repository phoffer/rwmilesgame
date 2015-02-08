class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.references :game, index: true
      t.integer :number
      t.integer :days
      t.integer :count
      t.integer :status
      t.string :thread_url

      t.timestamps null: false
    end
    add_foreign_key :weeks, :games
  end
end
