class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :game, index: true
      t.string :name
      t.string :slug
      t.integer :status,        default: 0
      t.boolean :allstar_bonus, default: false

      t.timestamps null: false
    end
    add_foreign_key :teams, :games
  end
end
