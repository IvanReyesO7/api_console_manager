class Application < ApplicationRecord
  belongs_to :user
  has_many :lists
  has_many :images
  has_many :codes 
  has_many :components
  has_many :read_tokens

  validates :name, presence: true, uniqueness: { scope: :user_id,
                                                 message: "You already have an app with that name."}

  after_create :generate_read_token

  def dev_link
    "localhost:3000/#{self.user.username}/#{self.name}"
  end

  def generate_read_token
    read_token = ReadToken.create!(name: 'master', application_id: self.id)
  end
end
