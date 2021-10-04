module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :titles, [Types::TitleType], description: 'Return all the titles due to search with partial name, empty search returns all', null: false do
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
        break if result != nil

        Title.custom_set_collection("titles#{i}")
        result = Title.find_by(tconst: tconst)
      end
      result
    end
  end
end
