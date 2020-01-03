class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン
      log_in user
      # Remember me チェックボックスの値に応じて処理
      # チェックしていたら、記憶トークンを生成してダイジェストをデータベースに保存
      # +トークンをCookieに保存
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # ユーザー情報のページか、元のページにリダイレクトする
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
