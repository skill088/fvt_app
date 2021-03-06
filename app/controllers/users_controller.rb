class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :admin_alive,     only: :destroy
  before_action :auth_user,   only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

	def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Профиль обновлён"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Добро пожаловать на FVT App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удалён"
    redirect_to users_url
  end

  def following
    @title = "Подписки"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], :per_page => 30)
    render 'show_follow'
  end

  def followers
    @title = "Подписчики"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def auth_user
      if signed_in?
        redirect_to root_url, notice: "Вы уже зарегистрированы!"
      end
    end

    # def signed_in_user
    #  unless signed_in?
    #     store_location
    #     redirect_to signin_url, notice: "Please sign in."
    #   end
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def admin_alive
      if current_user?(User.find(params[:id]))
        redirect_to users_url
      end
    end
end
