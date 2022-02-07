# frozen_string_literal: true

module Types
  class LoginType < Types::BaseObject
    description 'Login path return values Properties'

    field :session_key, String, null: true
    field :is_logged_in, Boolean, null: true
    field :user_mail, String, null: true
  end
end
