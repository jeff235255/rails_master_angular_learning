class User < ApplicationRecord
  TEMP_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable


  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    unless user
      email = auth.info.email
      user = User.where(email: email).first if email
      unless user
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email ? email : "",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end
    unless identity.user == user
      identity.user = user
      identity.save!
    end
    user
  end
  def email_verified?
    email.present? && !(email !~ TEMP_EMAIL_REGEX)
  end
end
