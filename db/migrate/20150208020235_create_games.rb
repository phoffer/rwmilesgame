class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :current_week_id, default: 0
      t.integer :year
      t.integer :status,          default: 0
      t.datetime :closes_at
      t.integer :count

      t.timestamps null: false
    end
  end
end
