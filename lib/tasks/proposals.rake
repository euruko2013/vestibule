namespace :proposals do
  task :prepare_for_phase_two => :environment do
    Proposal.update_phase_one_stats!
    Proposal.rank_phase_one!
    Proposal.nominate!
  end

  task :final_selections => :environment do
    User.all.each { |u| u.update_contribution_score! }
    Proposal.update_phase_two_stats!
    Proposal.rank_phase_two!
  end
end
