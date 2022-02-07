# frozen_string_literal: true

module Types
  class TitleType < Types::BaseObject
    description 'Title and related properties'

    field :_id, ID, null: false
    field :tconst, String, null: true
    field :titleType, String, null: true
    field :primaryTitle, String, null: true
    field :originalTitle, String, null: true
    field :isAdult, String, null: true
    field :startYear, String, null: true
    field :endYear, String, null: true
    field :runtimeMinutes, String, null: true
    field :genres, [String], null: true
    field :played_actors_id, [String], null: true
  end
end
