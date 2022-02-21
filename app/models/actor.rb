# frozen_string_literal: true

class Actor < ApplicationRecord
    self.primary_key = :nconst
    has_many :actor_movies
    has_many :movies, :through => :actor_movies, :foreign_key => :actor_id, :primary_key => :tconst
end
