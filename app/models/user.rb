class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

   def self.find_for_open_id_oauth(access_token, signed_in_resource=nil)
    email = access_token.info['email']
    if user = User.find_by_email(email)
      user
    else
      User.create!(:email => email, :password => Devise.friendly_token[0,20])
    end
  end

  has_many :templates
end
