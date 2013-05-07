class AddConfirmedFlagToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :confirmed, :boolean, :default => false
  end
end
