class Product < ApplicationRecord
    has_rich_text :description
    extend FriendlyId
    friendly_id :title, use: :slugged
end
