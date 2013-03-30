class AddSubscribeToSuggestionsNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribe_to_suggestions_notifications, :boolean, :default => true
  end
end
