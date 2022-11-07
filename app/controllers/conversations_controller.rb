class ConversationsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  # GET /conversations
  def index

    @users = User.all
    @conversations = Conversation.where(:recipient_id == current_user.id)
    @messages = Message.all

    #@pagy, @conversations = pagy(Conversation.sort_by_params(params[:sort], sort_direction))

    # We explicitly load the records to avoid triggering multiple DB calls in the views when checking if records exist and iterating over them.
    # Calling @conversations.any? in the view will use the loaded records to check existence instead of making an extra DB call.
    #@conversations.load
  end

  # GET /conversations/1
  def show
  end
  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    #redirect_to conversation_messages_path(@conversation)
    redirect_to conversation_messages_path(conversation_id: @conversation, product: params[:product])
  end




  # PATCH/PUT /conversations/1
  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: "Conversation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /conversations/1
  def destroy
    @conversation.destroy
    redirect_to conversations_url, notice: "Conversation was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  #def set_conversation
    #@conversation = Conversation.find(params[:id])
  #end

  # Only allow a trusted parameter "white list" through.
  #def conversation_params
    #params.require(:conversation).permit(:sender_id, :recipient_id)
  #end


  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end


end
