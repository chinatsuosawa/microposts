class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # SessionsHelperを読み込みstore_locationを使用可能に

  private
  def logged_in_user
    # ログインしていない場合のみ処理
    unless logged_in?
      # アクセスURLを保存
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end