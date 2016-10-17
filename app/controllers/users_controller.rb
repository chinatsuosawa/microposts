class UsersController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :followings, :followers]
  before_action :correct_user, only: [:edit, :update]

  def show 
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    # インスタンス生成
    @user = User.new
  end

  # アカウント作成
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

  # アカウント編集
  def edit
  end

  # アカウント更新
  def update
    # ユーザー情報更新（ハッシュごと）
    if @user.update_attributes(user_params)
      # 保存に成功した場合はshowへリダイレクト
      flash[:success] = "Update your profile."
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  # フォロー一覧取得
  def followings
    @title = "Follow users"
    @users = @user.following_users
    render 'show_follow'
  end

  # フォロワー一覧取得
  def followers
    @title = "Followes"
    @users = @user.follower_users
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :profile, :area)
  end

  # ユーザー情報取得
  def set_params
    @user = User.find(params[:id])
  end

  # リジェクト処理
  def correct_user
    redirect_to root_path if !current_user?(@user)
  end
end