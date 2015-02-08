class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :team, index: true
      t.references :week, index: true
      t.float :points
      t.float :total
      t.integer :mb
      t.integer :po
      t.float :high
      t.float :low
      t.float :avg
      t.integer :opponent

      t.timestamps null: false
    end
    add_foreign_key :scores, :teams
    add_foreign_key :scores, :weeks
  end
end
