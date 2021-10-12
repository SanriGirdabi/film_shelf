require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :request do

    let(:email) {"sercanuygur70@gmail.com"}

  describe 'CreateUser', type: :mutation do
    let(:mutation_string) do
      <<-GQL
        mutation createUser($email: String!, $password: String!) {
            createUser(input: { email: $email, password: $password }) {
              isLoggedIn
              sessionKeys
              email
              _id
              password
              createdAt
              updatedAt
            }
        }
    GQL
    end

    context 'when user is not created' do
      before do
        mutation(mutation_string, variables: variables, context: {})
      end

      it 'creates user' do
        expect(gql_response.data['createUser']['email']).to eq(email)
      end
    end

    context 'when user is already created' do
        before do
          mutation(mutation_string, variables: variables, context: {})
        end
  
        it 'can not creates user' do
          expect(gql_response.data['createUser']['sessionKeys']).to be_empty
        end
      end


    def variables
      {
        email: email,
        password: '123456789'
      }
    end
  end
end
