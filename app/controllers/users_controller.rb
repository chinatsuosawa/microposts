class UsersController < ApplicationController

  def show 
   # ユーザー情報取得
   @user = User.find(params[:id])
  end
  
  def new
    # インスタンス生成
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # フラッシュメッセージ表示
      flash[:success] = "Welcome to the Sample App!"
      # 新規登録後、ユーザー詳細ページへリダイレクト
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end