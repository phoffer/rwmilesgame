class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :current_week_id
      t.integer :year
      t.integer :status
      t.datetime :closes_at
      t.integer :count

      t.timestamps null: false
    end
  end
end
