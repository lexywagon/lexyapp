class UserMailerPreview < ActionMailer::Preview
  def update
    user = User.where(email: "valentin@escoyez.be")
    UserMailer.update(user)
  end
end
