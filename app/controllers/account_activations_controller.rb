class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # ユーザーが存在 かつ 有効化前 かつ
    # params[:id]で渡されたトークンから生成したハッシュ値がダイジェストと一致したら
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # 有効化状態にする
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      # ログインさせる
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      # 有効化失敗
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
