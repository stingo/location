class Product < ApplicationRecord
    has_rich_text :description
    extend FriendlyId
    friendly_id :title, use: :slugged

 # Single image upload
  #has_one_attached :images
  # Multiple images upload
  #has_many_attached :images
  #has_one_attached :avatar
  has_many_attached :product_images
  has_many :messages
  belongs_to :user
  has_rich_text :description

end
