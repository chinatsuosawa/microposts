class User < ActiveRecord::Base

  # コールバック
  # メールアドレスのアルファベットを小文字に
  before_save { self.email = self.email.downcase }

  # nameは必須かつ最大文字数は50文字
  validates :name, presence: true, length: { maximum: 50 }

  # 正規表現パターン
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # emailは必須かつ255文字以内でVALID_EMAIL_REGEXに一致しユニークであること
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # データベースに安全にハッシュ化（暗号化）されたpassword_digestを保存する
  # passwordとpassword_confirmationをモデルに追加して、パスワードの確認が一致するか検証する
  # パスワードが正しいときに、ユーザーを返すauthenticateメソッドを提供する
  has_secure_password

  # 更新時のみ有効：profileが入力されていた場合、300文字以内であること
  validates :profile, absence: true, 
                      on: :create
  validates :profile, allow_blank: true, length: { maximum: 300 },
                      on: :update

  # 更新時のみ有効：areaが入力されていた場合、30文字以内であること
  validates :area, absence: true, 
                   on: :create
  validates :area, allow_blank: true, length: { maximum: 30 },
                   on: :update

  # それぞれのユーザーは複数の投稿を持つことができる
  has_many :microposts

  # ユーザーがフォローしているアカウントを取得（フォロー）
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed

  # ユーザーをフォローしているアカウントを取得（フォロワー）
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower


  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end

  # 自分とフォローしているユーザーのつぶやきを取得する
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end

  # お気に入りツイートを取得する
  has_many :favorites, foreign_key: 'user_id', dependent: :destroy
  has_many :favorite_microposts, through: :favorites, source: :micropost

  # お気に入り登録する
  def favorite(micropost)
      favorites.find_or_create_by(micropost_id: micropost.id)
  end
    
  # お気に入り解除する
  def unfavorite(micropost)
      favorite = favorites.find_by(micropost_id: micropost.id)
      favorite.destroy if favorite
    end
end