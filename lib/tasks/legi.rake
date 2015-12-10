namespace :legi do
  desc "Update law database"
  task update: :environment do
    UpdateArticlesJob.perform_later
  end
end
