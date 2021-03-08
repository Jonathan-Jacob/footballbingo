namespace :match do
  desc "update all matches to reflect matches between start date and end date"
  task update_matches: :environment do
    UpdateMatchesJob.perform_later
  end

  desc "update live scores of today's matches"
  task update_livescores: :environment do
    UpdateLivescoresJob.perform_later
  end
end
