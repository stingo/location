class UsersController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
  #skip_before_action :store_current_location_details, only: :edit
  before_action :authenticate_user!, except: %i[index show products]
  #rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
  before_action :set_user, only: %i[show edit update destroy products secondary_details]
  # impressionist actions: [:show,:index], unique: [:session_hash]



  # GET /users
  # GET /users.json
  def index
        if user_signed_in? && current_user.admin?

    #@users = User.all.order("created_at DESC").page params[:page]
    @sellplus_users = User.where(account_type: "SellPlus (Buy @ wholesale with upfrica)")

 

     @pagy, @users = pagy(User.order("created_at DESC").sort_by_params(params[:sort], sort_direction), items: 200)

    # We explicitly load the records to avoid triggering multiple DB calls in the views when checking if records exist and iterating over them.
    # Calling @product_types.any? in the view will use the loaded records to check existence instead of making an extra DB call.
    @users.load


    
  else 

  redirect_to root_path, alert: "Access Denied!" 
end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    

    @user_products = @user.products.order("created_at DESC") #important! to enable profiles urbanterms on profile
    @user_product = Product.where(:id => @user.id) #important! to enable profiles urbanterms on profile
    # impressionist(@user)
    #@user_posts = @user.posts.order("created_at DESC")

    # @user_posts = @user.posts.order("created_at DESC").published #important! to enable user posts on profile
    # @user_drafts = Post.order("created_at DESC").draft.where(:user_id => current_user) #important! to enable user drafts on index#page
    # @user_podcasts = @user.podcasts.order("created_at DESC").published #important! to enable user posts on profile
    # @user_bookmarks = @user.bookmarks.order("created_at DESC")
    #@user = User.friendly.find(params[:id])
    # @user = Post.friendly.find_by(username: params[:username])
    # render json: { user_id: params[:user_id] }.to_json

    @verifications = User.where(verified: "No").order("created_at DESC").page(params[:page]).per(15)
    @user = User.friendly.find(params[:id]) || User.find(params[:id])
    @products = @user.products
  end

  def new
    @user = User.new
  end


    def secondary_details
    @user = User.friendly.find(params[:id])
    @meta_title = "Complete account registration"
    @meta_description = "Upfrica SellPlus provides: product sourcing at wholesale prices, a dedicated online platform to sell your products and continues trafic to boost your sales"
    @seo_keywords = "Upfrica sellplus, Sell online in Ghana, Sell online free, shops in ghana, UK Africa market, UK ghana online site, upfrica, upfrica sell account"



  end

    def update_resource(resource, params)
    # Jumpstart: Allow user to edit their profile without password
    resource.update_without_password(params)
  end


  def my_sellplus
    @user = User.friendly.find(params[:id])
    @products = @user.products
    @meta_title = "SellPlus - Upfrica "
    @meta_description = "Upfrica SellPlus provides: product sourcing at wholesale prices, a dedicated online platform to sell your products and continues trafic to boost your sales"
    @seo_keywords = "Upfrica sellplus, Sell online in Ghana, Sell online free, shops in ghana, UK Africa market, UK ghana online site, upfrica, upfrica sell account"
  end

  def verification
    @user = User.friendly.find(params[:id])
    @products = @user.products
    # @currencies = Currency.all.map{|c| [ c.name, c.id ] }
  end

  def verifications
if user_signed_in? && current_user.admin?
     @verifications = User.where(verified: "No").order("created_at DESC").page(params[:page]).per(15)
    @user = User.friendly.find(params[:id])
    @products = @user.products   
   
    
  else  
redirect_to root_path, alert: "Access Denied!"
  end
  end


  def new_listing_approval
    if !current_user.admin?
    redirect_to root_path, alert: "Access Denied!"
  else  
    @product_drafts = Product.all.order("created_at DESC").includes(:category, :condition).draft.page(params[:page]).per(500)
    @user = User.friendly.find(params[:id])
    @products = @user.products
  end
  end

  def toggle_status
    # byebug used for debugging
    if @product.draft?
      @product.published!
    elsif @product.published?
      @product.draft!
    end

    redirect_to action: :new_listing_approval, notice: "Product status has been updated."


  end


    def waiting_approval
    if current_user != @user || !current_user.admin?
    redirect_to root_path, alert: "Access Denied!"
  else  
    @waiting_approval = @user.products.order("created_at DESC").draft
    @user = User.friendly.find(params[:id])
    @products = @user.products
  end
  end


    def products
    @user = User.friendly.find(params[:id])
    @products = @user.products.published
    # @currencies = Currency.all.map{|c| [ c.name, c.id ] }
    @waiting_approval = @user.products.order("created_at DESC").draft
  end

  # GET /users/1/edit
  def edit
    # @tag = Tag.new
    @user = User.friendly.find(params[:id])
  end

  # POST /users

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    user = User.friendly.find(params[:id])
    # @locations = Location.all.map{|c| [ c.country, c.id ] }

    respond_to do |format|
      if @user.update(user_params)
        #format.html { redirect_to request.referrer, notice: "Details were submitted."} #redirect_to @user, notice: "User was successfully updated." }
        format.html { redirect_to request.referrer} #redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end




  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end




  # def following
  # @title = "Following"
  # @user  = User.find(params[:id])
  # @users = @user.following#.paginate(page: params[:page])
  # render 'show_following'
  # end

  # def followers
  # @title = "Followers"
  # @user  = User.find(params[:id])
  # @users = @user.followers#.paginate(page: params[:page])
  # render 'show_followers'
  # end

  # redirect to same page after sign in
  # def store_location
  # if(request.path != "/users/sign_in" &&
  # request.path != "/users/sign_up" &&
  # request.path != "/users/password/new" &&
  # request.path != "/users/password/edit" &&
  # request.path != "/users/confirmation" &&
  # request.path != "/users/sign_out" &&
  # !request.xhr? && !current_user) # don't store ajax calls
  # session[:previous_url] = request.fullpath
  # end
  # end
  # def after_sign_in_path_for(resource)
  # previous_path = session[:previous_url]
  # session[:previous_url] = nil
  # previous_path || root_path
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.friendly.find(params[:id])
  end

  def invalid_user
    logger.error "Attempt to access invalid user #{params[:id]}"
    redirect_to root_path, notice: "That user doesn't exist"
  end




  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :username, :first_name, :last_name, :email, :slug )
  end
end
