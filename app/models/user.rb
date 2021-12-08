class User < ApplicationRecord
  has_many :applications
  
  before_validation :generate_api_token
  validates :api_token, presence: true
  validates :username, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  private 
  def generate_api_token
    self.api_token = SecureRandom.hex(24)
  end
end
