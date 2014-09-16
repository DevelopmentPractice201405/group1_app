class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase }
  	before_create :create_remember_token
  	before_create :create_uid

  	validates :name, presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  	has_secure_password
  	validates :password, length: { minimum: 6 }


	def User.new_remember_token
    		SecureRandom.urlsafe_base64
  	end
  
   def feed
    Micropost.from_users_followed_by(self)
  end
  
  	def User.encrypt(token)
    		Digest::SHA1.hexdigest(token.to_s)
  	end

  #def feed
    # このコードは準備段階です。
    # 完全な実装は第11章「ユーザーをフォローする」を参照してください。
    #Micropost.where("user_id = ?", id)
  #end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def self.create_with_omniauth(auth)
      tmp_password = (("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a).shuffle[0..7].join
      create! do |user|
          user.provider = auth["provider"]
          user.uid = auth["uid"]
          user.name = auth["info"]["nickname"]
          user.email = User.create_unique_email
          user.password = tmp_password
          user.password_confirmation = tmp_password
      end
  end

  def self.create_unique_string
      SecureRandom.uuid
  end
   
    # twitterではemailを取得できないので、適当に一意のemailを生成
  def self.create_unique_email
      User.create_unique_string + "@example.com"
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def create_uid
        self.provider = "sample_app"
        begin
            self.uid = SecureRandom.random_number(1000000)
        end while self.class.exists?(uid: uid)
    end
end
