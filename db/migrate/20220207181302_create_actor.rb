class CreateActor < ActiveRecord::Migration[6.1]
  def change
    create_table :actors do |t|
      t.string :nconst
      t.string :primary_name
      t.string :birth_year
      t.string :death_year
      t.string :primary_profession, array: true, default: []
      t.string :known_for_titles, array: true, default: []

      t.timestamps
    end
  end
end
