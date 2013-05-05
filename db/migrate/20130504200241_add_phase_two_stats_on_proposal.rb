class AddPhaseTwoStatsOnProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :absolute_selections_score, :integer, :default => 0
    add_column :proposals, :bad_users_excluded_absolute_selections_score, :integer, :default => 0
    add_column :proposals, :user_weighted_selections_score, :float, :default => 0
    add_column :proposals, :phase_two_ranking, :integer
  end
end
