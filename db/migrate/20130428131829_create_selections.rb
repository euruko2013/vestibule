class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.references :user
      t.references :proposal
      t.integer :position

      t.timestamps
    end
    add_index :selections, :user_id
    add_index :selections, :proposal_id
    add_index :selections, [:user_id, :proposal_id], unique: true
    add_index :selections, [:user_id, :position], unique: true
  end
end
