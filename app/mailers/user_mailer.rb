class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.update.subject
  #
  def update((user, updated_docs))
    @user = user
    @greeting = "Good evening #{@user}"
    @updated_docs = updated_docs

    mail(to: @user.email, subject: 'New Lexy Alert - Law update')
  end
end
