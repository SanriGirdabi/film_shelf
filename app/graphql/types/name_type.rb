# frozen_string_literal: true

module Types
  class NameType < Types::BaseObject
    field :_id, ID, null: true
    field :nconst, String, null: true
    field :primaryName, String, null: true
    field :birthYear, String, null: true
    field :deathYear, String, null: true
    field :primaryProfession, String, null: true
    field :knownForTitles, [String], null: true
  end
end
