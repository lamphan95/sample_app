class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: I18n.t("mailers.user_mailer.account_activation.subject")
  end

  def password_reset
    @greeting = I18n.t "mailers.user_mailer.account_activation.hi"

    mail to: "to@example.org"
  end
end
