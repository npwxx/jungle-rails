class User < ActiveRecord::Base
  has_secure_password
  
  before_validation :strip_whitespace

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, length: { minimum: 4 }

  def strip_whitespace
    self.first_name.strip! unless self.first_name.nil?
    self.last_name.strip! unless self.last_name.nil?
    self.email.strip! unless self.email.nil?
  end

  def self.authenticate_with_credentials(email:, password:)
    user = User.where('lower(email) = ?', email.strip.downcase).first
    user && user.authenticate(password)? user : nil
  end
end
