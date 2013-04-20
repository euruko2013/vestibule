class AddDelegateToUser < ActiveRecord::Migration
  def change
    add_column :users, :delegate, :boolean, :default => false
  end
end
