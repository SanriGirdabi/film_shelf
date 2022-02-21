# frozen_string_literal: true

class Movie < ApplicationRecord
    self.primary_key = :tconst
    has_many :actor_movies
    has_many :actors, :through => :actor_movies, :foreign_key => :movie_id, :primary_key => :nconst
end
