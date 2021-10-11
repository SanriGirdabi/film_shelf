class Mutations::CreateUser < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true

  field :user, Types::UserType, null: true

  def resolve(email:, password:)
    user = User.new(email: email, password: BCrypt::Password.create(password))
  rescue Mongo::Error::OperationFailure => e
    if e.message.include? 'E11000'
      puts "Duplicate key error #{$!}"
      {}
    else
      raise e
    end
    if user.save
      user
    else
      user.errors.full_messages
    end
  end
end
