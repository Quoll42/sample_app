class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :signed_in_user2,only: [:new, :create]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
    if @user.save
    	sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
		else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      #Handle a successful update:
      flash[:success] = "Profile updated"
      sign_in @user #Done because the remember token gets reset when the user is saved
      redirect_to @user
    else
      #Handle failed update attempt:
      render 'edit'
    end
  end 

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = "I won't let you destroy yourself!"
    else
      User.find(params[:id]).destroy
      flash[:alert] = "Destroyed the user."
    end
    redirect_to users_url
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def signed_in_user2 #Prevent signed-in users from accessing new and create methods
    if signed_in?
      flash[:error] = "You are already signed in!"
      redirect_to root_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end