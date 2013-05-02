class AddPublishSelectionsFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :publish_selections, :boolean, :default => true
  end
end
