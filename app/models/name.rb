class Name
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: BSON::ObjectId
  field :nconst, type: String
  field :primaryName, type: String
  field :birthYear, type: String
  field :deathYear, type: String
  field :primaryProfession, type: String
  field :knownForTitles, type: Array

  has_and_belongs_to_many :titles, primary_key: :tconst, foreign_key: :knownForTitles,
  # inverse_primary_key: :_id, inverse_foreign_key: :played_actors_id
  inverse_of: nil

  def self.custom_set_collection(selected_collection)
    store_in collection: selected_collection
  end
end
