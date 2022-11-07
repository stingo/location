# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint
#  product_id      :integer
#  user_id         :bigint
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_product_id       (product_id)
#  index_messages_on_user_id          (user_id)
#
class Message < ApplicationRecord
 belongs_to :conversation
 belongs_to :user
 belongs_to :product, optional: true
 has_many_attached :message_images, dependent: :destroy
 has_rich_text :body
 default_scope -> { order(updated_at: :ASC) }

  # Broadcast changes in realtime with Hotwire#
  #after_create_commit  -> { broadcast_prepend_later_to :messages, partial: "messages/index", locals: { contact: self } }
  #after_update_commit  -> { broadcast_replace_later_to self }
  #after_destroy_commit -> { broadcast_remove_to :messages, target: dom_id(self, :index) }



 validates_presence_of :body, presence: true #:conversation_id, :use_id

 def message_time
  created_at.strftime("%b %d, %Y at %l:%M %p")
 end
end
