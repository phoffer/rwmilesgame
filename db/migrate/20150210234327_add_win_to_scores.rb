class AddWinToScores < ActiveRecord::Migration
  def change
    add_column :scores, :win, :boolean
  end
end
