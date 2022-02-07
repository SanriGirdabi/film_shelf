# frozen_string_literal: true

desc 'Add name ids to titles'

task :title_modifier do
  client = Mongo::Client.new(['127.0.0.1:27017'], database: 'film_shelf_development')
  k = 0

  (0..450).each do |y|
    client["names#{y}"].find({}, projection: { 'knownForTitles': 1, '_id': 1 }).each do |name_object|
      name_object['knownForTitles'].each do |single_value|
        (0..332).each do |i|
          client["titles#{i}"].update_many({ tconst: single_value.to_s },
                                           { "$push": { played_actors_id: name_object['_id'] } })
          k += 1
        end
      end
      p name_object
    end
  end
end
