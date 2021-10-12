class Mutations::CreateUser < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true

  field :user, Types::UserType, null: true

  def resolve(email:, password:)
    user = User.new(email: email, password: BCrypt::Password.create(password))
    if user&.save
      user
    else
      user.errors.full_messages
    end
  rescue Mongo::Error::OperationFailure => e
    user
    
  end
end
