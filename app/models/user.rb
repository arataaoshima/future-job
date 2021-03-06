class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :lecture_users
  has_many :lectures, through: :lecture_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :trackable

    after_create :send_welcome_mail

     def send_welcome_mail
       UserMailer.user_welcome_mail(self).deliver
     end

    def self.find_for_google_oauth2(auth)
     user = User.where(email: auth.info.email).first
    unless user
      user = User.create(name:     auth.info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         token:    auth.credentials.token,
                         password: Devise.friendly_token[0, 20])
    end
     user
    end

    def update_without_current_password(params, *options)
        params.delete(:current_password)

        if params[:password].blank? && params[:password_confirmation].blank?
          params.delete(:password)
          params.delete(:password_confirmation)
        end

        result = update_attributes(params, *options)
        clean_up_passwords
        result
    end
end
