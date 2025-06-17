class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy #「一人のユーザーは複数の投稿を持つ」という関係を表す
  has_many :comments, dependent: :destroy #Userが削除された時にそのユーザーのコメントも全て削除される
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :view_counts, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  attachment :profile_image

  validates :name, presence: true

  GUEST_EMAIL = "guest@example.com".freeze

  # クラスメソッド：既定のゲストを取得／作成して返す
  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |u|
      u.password = SecureRandom.urlsafe_base64(12)
      u.name = "ゲスト"
      u.profile_image = nil
    end
  end

  # インスタンスメソッド：ゲストかどうか判定
  def guest?
    email == GUEST_EMAIL
  end

  #ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  #ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  #フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  #ユーザーにフォローされていればtrueを返す
  def followed_by?(user)
    follower_user.include?(user)
  end
end
