class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def twitter_create
      auth = request.env["omniauth.auth"]
      puts"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts auth["info"]["nickname"]
      puts auth["info"]["image"]
      puts auth["info"]["urls"]["Twitter"]
      puts"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      session[:screen_name] = auth["info"]["nickname"]
      session[:twitter_icon] = auth["info"]["image"]
      session[:twitter_url] = auth["info"]["urls"]["Twitter"]
      session[:oauth_token] = auth.credentials.token
      session[:oauth_token_secret] = auth.credentials.secret
      sign_in user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to root_url
  end

  def twitter_destroy
        session[:user_id] = nil
          redirect_to root_url, :notice => "Signed out!"
  end
end
