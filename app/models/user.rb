class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :email, type: String
  field :password, type: String
  field :created_at, type: Time
  field :updated_at, type: Time
  field :_id, type: BSON::ObjectId
  field :session_keys, type: Array, default: []
  field :is_logged_in, type: Boolean, default: false
  field :favorite_movies, type: Array, default: []
  field :followed_genres, type: Array, default: []
  field :favorite_actors, type: Array, default: []

  after_create do
    client = Mongo::Client.new(['127.0.0.1:27017'], database: 'film_shelf_development', collection: 'users') if Rails.env.development?

    client = Mongo::Client.new('://dbUser:Xm!4NU$X*TkWEKe@cluster0.cat4j.mongodb.net/film_shelf_production?retryWrites=true&w=majority') if Rails.env.production?

    a = client['users']

    a.indexes.create_one({ email: 1 }, { unique: true, background: true, expire_after_seconds: 1 })
  end

  def self.is_user_logged_in(session_key)
    current_user(session_key)[:is_logged_in]
  end

  def self.current_user(session_key)
    User.where(session_keys: { "$all" => [session_key] }).first
  end

  has_many :sessions, primary_key: :_id, foreign_key: :user_id, autosave: true, inverse_of: :user

  store_in collection: 'users', database: 'film_shelf_development' if Rails.env.development?

  store_in collection: 'users', database: 'film_shelf_production' if Rails.env.production?

  include Mongoid::Timestamps
end
