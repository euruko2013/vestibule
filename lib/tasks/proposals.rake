namespace :proposals do
  task :prepare_for_phase_two => :environment do
    Proposal.update_phase_one_stats!
    Proposal.rank_phase_one!
    Proposal.nominate!
  end
end
