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

end