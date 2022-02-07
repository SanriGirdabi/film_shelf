class CreateMovie < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :tconst
      t.string :title_type
      t.string :primary_title
      t.string :original_title
      t.string :is_adult
      t.string :start_year
      t.string :end_year
      t.string :runtime_minutes
      t.string :genres, array: true, default: []

      t.timestamps
    end
  end
end
