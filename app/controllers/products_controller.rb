class ProductsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
    @conversation = Conversation.new
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    @message = @conversation.messages.new

    respond_to do |format|
      format.html {}
      format.js  {}
    end
  end

  # GET /products/new
  def new
      #@user = User.friendly.find(current_user.id)
      @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @user = User.friendly.find(current_user.id)
    @product = Product.friendly.find(params[:id])
  end

  # POST /products or /products.json
  def create
 
    @product = current_user.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
       @product = Product.friendly.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      #Replaced with Friendly
      @product = Product.friendly.find(params[:id])
      # @product = Product.find(params[:id])
    end



  def conversation_params
    params.require(:conversation).permit(:sender_id, :recipient_id)
    #params.require(:message).permit(:body, :user_id, :product_id, :message_images, :conversation_id)
  end

  def message_params
    params.require(:message).permit(:body, :user_id, :product_id, :message_images, :conversation_id)
  end


    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :price, :description, :user_id, :avatar, product_images: [])
    end
end
