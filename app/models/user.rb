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
  field :user_suggestions, type: Array, default: []

  after_create do
    client = Mongo::Client.new(['127.0.0.1:27017'], database: 'film_shelf_development', collection: 'users')

    a = client['users']

    a.indexes.create_one({ email: 1 }, { unique: true, background: true, expire_after_seconds: 1 })
  end

  def self.is_user_logged_in(session_key)
    current_user(session_key)[:is_logged_in]
  end

  def self.user_suggestions(current_user)
    if current_user['followed_genres'].length >= 2
      all = []
      selection = []
      final = []

      (0..332).each do |i|
        Title.custom_set_collection("titles#{i}")
        all.concat(Title.where(genres: { '$in' => current_user['followed_genres'] }).limit(200).as_json)
      end
      current_user['followed_genres'].each do |genre|
        all.each do |item|
          point = 0

          while item['genres']&.include?(genre)
            break if point == current_user['followed_genres']&.length

            point += 1
          end
          selection.push({ point: point, movie: item['originalTitle'] })
        end
      end

      a = selection.sort_by do |item|
        item.values[0]
      end
      a.reverse[0..24].each do |item|
        final.push(item[:movie])
      end
    end
    final
  end

  def self.current_user(session_key)
    User.where(session_keys: { "$all": [session_key] }).first
  end

  has_many :sessions, primary_key: :_id, foreign_key: :user_id, autosave: true, inverse_of: :user

  store_in collection: 'users', database: 'film_shelf_development'

  include Mongoid::Timestamps
end
