namespace :users_sync do
  desc 'Sync delegates from Mailchimp list'
  task :sync_delegates => :environment do
    delegates = Gibbon.list_members({:id => ENV['MAILCHIMP_DELEGATES_LIST_ID']})['data']
    delegates.each do |delegate|
      if (user = User.find_by_email(delegate['email']))
        user.delegate = true
        user.save!
      end
    end
  end
end
