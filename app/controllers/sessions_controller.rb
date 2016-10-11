class SessionsController < ApplicationController
  def new
  end

  # ログイン
  def create
    # 画面入力項目を取得
    @user = User.find_by(email: params[:session][:email].downcase)

    # ユーザーをメールアドレスから検索
    # 見つかった場合、authenticateメソッドでパスワードチェック
    if @user && @user.authenticate(params[:session][:password])

      # session[:user_id]へユーザーID格納
      session[:user_id] = @user.id
      flash[:info] = "logged in as #{@user.name}"
      # ユーザー詳細ページへリダイレクト
      redirect_to @user

    # 見つからなかった場合
    else
      # フラッシュメッセージ登録
      flash[:danger] = 'invalid email/password combination'
      # newテンプレート表示
      render 'new'
    end
  end

  # ログアウト
  def destroy
    # セッションをnilに
    session[:user_id] = nil
    # アプリケーションルート"/"へリダイレクト 
    redirect_to root_path
  end

end