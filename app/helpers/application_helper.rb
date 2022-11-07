module ApplicationHelper
  def direct_upload_token(string)
    ActiveStorage::DirectUploadToken.generate_direct_upload_token(string, ActiveStorage::Blob.service.name, session)
  end

    def message_recipient
    if @conversation.sender_id == current_user.id || @conversation.recipient_id == current_user.id
      if @conversation.sender_id == current_user.id
        User.find(@conversation.recipient_id)
      else
        User.find(@conversation.sender_id)
      end
    end
  end

  
end
