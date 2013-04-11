class AddLastVisitedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_visited_at, :datetime
  end
end
