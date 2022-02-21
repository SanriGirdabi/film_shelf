class CreateActorMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :actor_movies do |t|
      t.string :movie_id
      t.string :actor_id

      t.timestamps
    end
  end
end
