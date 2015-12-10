class UpdateArticlesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
    p "test job"
  end
end
