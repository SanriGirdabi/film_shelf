class Title
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: BSON::ObjectId
  field :tconst, type: String
  field :titleType, type: String
  field :primaryTitle, type: String
  field :originalTitle, type: String
  field :isAdult, type: String
  field :startYear, type: String
  field :endYear, type: String
  field :runtimeMinutes, type: String
  field :genres, type: Array
  field :played_actors_id, type: Array

  # has_and_belongs_to_many :names, primary_key: :_id, foreign_key: :played_actors_id,
  # inverse_primary_key: :tconst, inverse_foreign_key: :knownForTitles

  def self.custom_set_collection(selected_collection)
    store_in collection: selected_collection
  end
end
