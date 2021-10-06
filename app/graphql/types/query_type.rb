module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :titles, [Types::TitleType],
          description: 'Return all the titles due to search with partial name, empty search returns all', null: false do
      argument :originalTitle, String, required: true
    end

    def titles(originalTitle:)
      result = []
      (0..332).each do |i|
        Title.custom_set_collection("titles#{i}")
        result.concat(Title.all.where(originalTitle: BSON::Regexp::Raw.new("^#{originalTitle}")))
      end
      result
    end

    field :title, Types::TitleType, description: 'Return one title due to search with tconst', null: false do
      argument :tconst, String, required: true
    end

    def title(tconst:)
      result = nil
      (0..332).each do |i|
        break unless result.nil?

        Title.custom_set_collection("titles#{i}")
        result = Title.find_by(tconst: tconst)
      end
      result
    end

    field :names, [Types::NameType],
          description: 'Return all the names due to search with partial name, empty search returns all', null: false do
      argument :primaryName, String, required: true
    end

    def names(primaryName:)
      result = []
      (0..450).each do |i|
        Name.custom_set_collection("names#{i}")
        result.concat(Name.all.where(primaryName: BSON::Regexp::Raw.new("^#{primaryName}")))
      end
      result
    end

    field :name, Types::NameType, description: 'Return one name due to search with nconst', null: false do
      argument :nconst, String, required: true
    end

    def name(nconst:)
      result = nil
      (0..450).each do |i|
        break unless result.nil?

        Name.custom_set_collection("names#{i}")
        result = Name.find_by(nconst: nconst)
      end
      result
    end

    field :login, Types::LoginType, null: true, description: 'Login a user' do
      argument :email, String, required: true
      argument :password, String, required: true
    end

    def login(email:, password:)
      answer = {}
      user = User.find_by({ email: email })
      User.where(email: email).map { |h| answer.merge!('password': h['password'], email: h['email']) }

      user_password_decyrpted = BCrypt::Password.new(answer[:password])

      if user_password_decyrpted == password && email == answer[:email]
        session = user.sessions.create
        User.where(email: email).update({ '$push' => { session_keys: session.key } })
        User.where(email: email).update({ '$set' => { is_logged_in: true } })
        { session_key: session.key, is_logged_in: true, user_mail: answer[:email] }
      else
        { session_key: nil, is_logged_in: false, user_mail: answer[:email] }
      end
    end

    field :update_password, Types::UserType, null: true, description: 'Update a user password' do
      argument :new_password, String, required: true
      argument :session_key, String, required: true
    end

    def update_password(new_password:, session_key:)
      User.current_user(session_key).update({ password: BCrypt::Password.create(new_password) }) if User.is_user_logged_in(session_key)
      User.current_user(session_key)
    end

    field :users, [Types::UserType], null: true

    def users
      User.all
    end
  end
end
