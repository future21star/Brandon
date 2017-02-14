class QuotrMailer < ActionMailer::Base

  def system_message(subject, body)
    return mail(to: SERVER_ADMIN, subject: subject, body: body)
  end

  def generate_message(user, subject, body)
    return mail(to: user.email, subject: subject, body: body)
  end
end
