class User
  include Mongoid::Document
  
  field :email, type: String
  field :password, type: String
  field :created_at, type: Time
  field :updated_at, type: Time
  field :_id, type: BSON::ObjectId
  field :session_id, type: Float

  after_create do
    client = Mongo::Client.new(['127.0.0.1:27017'], database: 'film_shelf_development', collection: 'users')

    a = client['users']

    a.indexes.create_one({ email: 1 }, { unique: true, background: true, expire_after_seconds: 1})
end

has_many :sessions, primary_key: :_id, foreign_key: :session_id

  store_in collection: "users", database: "film_shelf_development"

  include Mongoid::Timestamps
end
