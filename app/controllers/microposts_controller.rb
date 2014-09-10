class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      puts "============================================"
      puts session[:oauth_token]
      puts session[:oauth_token_secret]
      puts params[:twitter][:flag]
      puts "============================================"
      if params[:twitter][:flag] == 'yes'
          client = Twitter::REST::Client.new do |config|
              config.consumer_key        = ENV['TWITTER_KEY']
              config.consumer_secret     = ENV['TWITTER_SECRET']
              config.access_token        = session[:oauth_token]
              config.access_token_secret = session[:oauth_token_secret]
          end
          puts params[:micropost][:content]
          client.update(params[:micropost][:content])
      end
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

 
 private

    def micropost_params
      params.require(:micropost).permit(:content, :twitter, :locate, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
