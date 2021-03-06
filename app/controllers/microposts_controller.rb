class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Сообщение опубликовано!"
      redirect_to root_url
    else
      #@feed_items = microposts
      #render 'static_pages/home'
      #flash[:error] = "Error: Micropost should not be blank!"
      redirect_to root_url, notice: "Публикация не должна быть пустой!"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end