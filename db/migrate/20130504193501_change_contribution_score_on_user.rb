class ChangeContributionScoreOnUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :contribution_score
    add_column :users, :contribution_score, :float
    User.all.each { |u| u.update_contribution_score! }
  end

  def self.down
    remove_column :users, :contribution_score
    add_column :users, :contribution_score, :integer
  end
end
