module SessionsHelper

  # ログイン中の場合はログインユーザーを、ログインしていない場合はnilを返す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  # アクセスURLを保存
  def store_location 
    session[:forwarding_url] = request.url if request.get?
  end

  def current_user?(user)
    user == current_user
  end

end