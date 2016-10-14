class Micropost < ActiveRecord::Base

  # それぞれの投稿は特定の1人のユーザーのものである
  belongs_to :user

  # user_idが存在する
  validates :user_id, presence: true
  # contentが存在し、文字数は140
  validates :content, presence: true, length: { maximum: 140 }

end
