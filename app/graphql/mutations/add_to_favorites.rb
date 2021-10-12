class Mutations::AddToFavorites < Mutations::BaseMutation
  argument :session_key, String, required: true
  argument :use_case, String, required: true
  argument :result, String, required: true
  argument :email, String, required: true

  field :add_to_favorites, Types::UserType, null: true

  def resolve(session_key:, use_case:, result:, email:)
    if User.is_user_logged_in(session_key)
      
      if User.where(email: email).where(use_case.to_sym => result).to_a.empty?
        user = User.where(email: email)
        user.update({ '$push': { use_case => result } })
        user.update({ '$set': { user_suggestions: User.user_suggestions(User.current_user(session_key)) } })
      end
    end

    User.current_user(session_key)
  end
end
