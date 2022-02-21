# frozen_string_literal: true

class ActorMovie < ApplicationRecord
    belongs_to :movie, :foreign_key => :actor_id, :primary_key => :crew
    belongs_to :actor, :foreign_key => :movie_id, :primary_key => :known_for_titles
end