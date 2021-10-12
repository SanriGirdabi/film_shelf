require 'rails_helper'

RSpec.describe Mutations::AddToFavorites, type: :request do
  let(:email) { 'sercanuygur@gmail.com' }
  let(:password) { '123456789' }
  let(:session_key) { "6441da06efb3227e162a9b6eb4436fc4dc15a2be" }
  let(:selection) { 'tt1234567' }

  describe 'Add to Favorites', type: :mutation do

    let(:add_to_fav_string) do
      <<-GQL
        mutation addToFavorites($email: String!, $useCase: String!, $result: String!, $sessionKey: String!) {
            addToFavorites(input: { email: $email, useCase: $useCase, result: $result, sessionKey: $sessionKey }) {
              isLoggedIn
              sessionKeys
              email
              _id
              password
              createdAt
              updatedAt
              favoriteMovies
            }
          }
      GQL
    end

    context 'Addition to favorites' do
      before do
        mutation(add_to_fav_string, variables: add_to_variables, context: {})
      end
      it 'Adds a movie to favorites' do
        expect(gql_response.data['addToFavorites']['favoriteMovies']).to include(selection)
      end
    end

    def variables
      {
        email: email,
        password: password
      }
    end

    def add_to_variables
      {
        email: email,
        useCase: 'favorite_movies',
        result: selection,
        sessionKey: session_key
      }
    end
  end
end
