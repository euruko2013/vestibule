class AddModeratorFields < ActiveRecord::Migration
  def change
    add_column :users, :is_moderator, :boolean, :null => false, :default => false
    add_column :users, :last_visited_at, :datetime
  end
end
