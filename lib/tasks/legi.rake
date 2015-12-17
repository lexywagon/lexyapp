namespace :legi do
  desc "Update law database"
  task update: :environment do
    UpdateArticlesJob.perform_later
  end
  task fake: :environment do
    FakeUpdateJob.perform_later
  end
end
