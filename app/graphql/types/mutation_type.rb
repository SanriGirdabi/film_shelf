module Types
  class MutationType < Types::BaseObject
    field :create_user, type: Types::UserType, mutation: Mutations::CreateUser
  end
end
