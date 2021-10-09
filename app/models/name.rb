class Name
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :_id, type: BSON::ObjectId
  field :nconst, type: String
  field :primaryName, type: String
  field :birthYear, type: String
  field :deathYear, type: String
  field :primaryProfession, type: String
  field :knownForTitles, type: Array

  has_and_belongs_to_many :titles, class_name: 'Title', inverse_of: :titles, primary_key: :nconst, foreign_key: :knownForTitles, autosave: true

  def self.custom_set_collection(selected_collection)
    store_in collection: selected_collection
  end
end
