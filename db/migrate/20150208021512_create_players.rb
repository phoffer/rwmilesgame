class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :team, index: true
      t.string :name
      t.string :slug
      t.integer :goal,        default: 0
      t.float :total,         default: 0
      t.integer :status,      default: 0
      t.boolean :captain,     default: false
      t.string :cell_number
      t.string :cell_provider

      t.timestamps null: false
    end
    add_foreign_key :players, :teams
  end
end
