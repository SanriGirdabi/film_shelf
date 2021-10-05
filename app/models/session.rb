class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: BSON::ObjectId
  field :user_id, type: Integer
  field :key, type: String


  belongs_to :user, primary_key: :id, foreign_key: :session_id

  store_in collection: "sessions", database: "film_shelf_development"

  before_create do
    self.key = SecureRandom.hex(20)
  end
end
