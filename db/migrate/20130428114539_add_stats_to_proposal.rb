class AddStatsToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :nominated, :boolean, :default => false
    add_column :proposals, :counted_impressions, :integer, :default => 0
    add_column :proposals, :counted_votes_for, :integer, :default => 0
    add_column :proposals, :counted_votes_against, :integer, :default => 0
    add_column :proposals, :votes_wilson_score, :float
    add_column :proposals, :views_wilson_score, :float
    add_column :proposals, :total_wilson_score, :float
    add_column :proposals, :phase_one_ranking, :integer
  end
end
