require './lib/rich_text_figure' #product_chat
class MessagesController < ApplicationController
  before_action :authenticate_user!
   before_action :require_same_user, only: [:edit, :update, :destroy]
  

  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @product = Product.find_by(id: params[:product])
    #@users = user.all
    #@conversations = Conversation.all
    @conversations = Conversation.where(:recipient_id == current_user.id)#.page(params[:page]).per(10)



  @conversations_c = Conversation.all.where(:sender_id == current_user.id || :recipient_id == current_user.id)

   @conversation_messeges = Message.all.where(:user_id == current_user.id )


    @messages = @conversation.messages
    if @messages.length > 20
      @over_ten = true
      @messages = @messages[-20..-1]


    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end

    @message = @conversation.messages.new
  end

  def show
  @message_recipient = @message.user.where(conversation.recipient_id == user.id)  

  end

  def new
    @message = @conversation.messages.new
  end

  def create
    user_id = current_user.id
    @message = @conversation.messages.new(message_params)
    
    #product_chat
    send_product_message if params[:product_id].present?
    if @message.save
      #ConversationMailer.with(conversation: @conversation).new_conversation_mailer.deliver_now
#MessageNotificationMailer.with(message: @message).new_message_notification_mailer.deliver_now
      redirect_to conversation_messages_path(@conversation)
    end
  end

    def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def require_same_user
  if current_user != @message.user and !current_user.admin?
    flash[:danger] = "Access Denied!"
    redirect_to messages_path
  end  
end




private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end



  def message_params
    params.require(:message).permit(:body, :user_id, :product_id, :message_images, :conversation_id)
  end


 def send_product_message
    body = RichTextFigure.new(params[:product_id], request.base_url).rich_text_figure
    Message.create!(user_id: current_user.id, conversation_id: params[:conversation_id], body: body)
  end


end


