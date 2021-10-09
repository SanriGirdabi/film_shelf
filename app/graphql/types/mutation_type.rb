module Types
  class MutationType < Types::BaseObject
    field :create_user, type: Types::UserType, mutation: Mutations::CreateUser
    field :add_to_favorites, type: Types::UserType, mutation: Mutations::AddToFavorites
  end
end
