class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :player, index: true
      t.references :week, index: true
      t.references :score, index: true
      t.float :total
      t.integer :status
      t.datetime :posted_at

      t.timestamps null: false
    end
    add_foreign_key :posts, :players
    add_foreign_key :posts, :weeks
    add_foreign_key :posts, :scores
  end
end
