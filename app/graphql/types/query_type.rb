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
      if originalTitle.length >= 4
        (0..332).each do |i|
          Title.custom_set_collection("titles#{i}")
          result.concat(Title.where(originalTitle: BSON::Regexp::Raw.new("^#{originalTitle}")))
        end
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
        result = Title.where(tconst: tconst).first
      end
      result
    end

    field :names, [Types::NameType],
          description: 'Return all the names due to search with partial name, empty search returns all', null: false do
      argument :primaryName, String, required: true
    end

    def names(primaryName:)
      result = []
      if primaryName.length >= 3
        (0..450).each do |i|
          Name.custom_set_collection("names#{i}")
          result.concat(Name.all.where(primaryName: BSON::Regexp::Raw.new("^#{primaryName}")))
        end
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
        result = Name.where(nconst: nconst).first
      end
      result
    end

    field :login, Types::LoginType, null: true, description: 'Login a user' do
      argument :email, String, required: true
      argument :password, String, required: true
    end

    def login(email:, password:)
      answer = {}
      user = User.where({ email: email }).first

      if user
        User.where(email: email).map { |h| answer.merge!('password': h['password'], email: h['email']) }

        user_password_decyrpted = BCrypt::Password.new(answer[:password])
      end

      if user && user_password_decyrpted == password && email == answer[:email]
        session = user.sessions.create
        User.where(email: email).update({ '$push' => { session_keys: session.key } })
        User.where(email: email).update({ '$set' => { is_logged_in: true } })
        { session_key: session.key, is_logged_in: true, user_mail: answer[:email] }
      elsif user && user_password_decyrpted != password && email == answer[:email]
        { session_key: nil, is_logged_in: false, user_mail: answer[:email] }
      else
        { session_key: nil, is_logged_in: false, user_mail: nil }
      end
    end

    field :update_password, Types::UserType, null: true, description: 'Update a user password' do
      argument :new_password, String, required: true
      argument :session_key, String, required: true
    end

    def update_password(new_password:, session_key:)
      if User.is_user_logged_in(session_key)
        User.current_user(session_key).update({ password: BCrypt::Password.create(new_password) })
      end
      User.current_user(session_key)
    end

    field :users, [Types::UserType], null: true

    def users
      User.all
    end

    field :user, Types::UserType, null: true do
      argument :email, String, required: true
    end

    def user(email:)
      User.where(email: email).first
    end

    field :log_out, Types::UserType, null: true do
      argument :session_key, String, required: true
      argument :email, String, required: true
    end

    def log_out(session_key:, email:)
      user = User.where(email: email).first
      User.where(email: email).update({ '$set' => { is_logged_in: false } })
      user.pull(session_keys: session_key)
    end

    field :featured_movies, [Types::TitleType], null: true

    def featured_movies
      Title.custom_set_collection("titles#{Random.rand(10)}")
      Title.all.offset(3).limit(10).as_json
    end
  end
end
