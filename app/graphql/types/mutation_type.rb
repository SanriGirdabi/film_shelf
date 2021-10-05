require 'bcrypt'

module Types
  class MutationType < Types::BaseObject
    field :create_user, UserType, null: true do
      argument :email, String, required: true
      argument :password, String, required: true
    end

    def create_user(email:, password:)
      user = User.new(email: email, password: BCrypt::Password.create(password))

      if user.save
        user
      else
        user.errors.full_messages
      end
    end
  end
end
