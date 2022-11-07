class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_many :conversations, :foreign_key => :sender_id, dependent: :destroy
  # friendly url
  extend FriendlyId
  friendly_id :username, use: :slugged

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_admin?
    role.name == 'admin'
  end
end
