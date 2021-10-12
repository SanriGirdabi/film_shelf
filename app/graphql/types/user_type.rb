module Types
  class UserType < Types::BaseObject
    description 'User Properties'

    field :email, String, null: false
    field :password, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :_id, ID, null: true
    field :session_keys, [String], null: true
    field :is_logged_in, Boolean, null: false
    field :favorite_movies, [String], null: true
    field :followed_genres, [String], null: true
    field :favorite_actors, [String], null: true
    field :user_suggestions, [String], null: true

  end
end
