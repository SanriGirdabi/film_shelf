# frozen_string_literal: true

class AddCrewToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :crew, :string, array: true, default: []
  end
end
