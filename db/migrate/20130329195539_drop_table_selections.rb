class DropTableSelections < ActiveRecord::Migration
  def self.up
    drop_table :selections
  end

  def self.down
    create_table :selections, :force => true do |t|
      t.integer :proposal_id
      t.integer :user_id
    end
  end
end
