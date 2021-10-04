desc 'Create a mongoDB from the json files'

task :db_creator_custom do
  client = Mongo::Client.new(['127.0.0.1:27017'], database: 'film_shelf_development')

  (0..332).each do |i|

    titles = JSON.parse(File.read("#{Dir.pwd}/public/title_jsons/title#{i}.json"))
    titles.map do |title_hash|
      title_hash['genres'] = title_hash['genres'].split(',').to_a
    end

    client["titles#{i}"].insert_many(titles)
  end

  (0..450).each do |i|
    names = JSON.parse(File.read("#{Dir.pwd}/public/name_jsons/name#{i}.json"))
    names.map do |name_hash|
      name_hash['knownForTitles'] = name_hash['knownForTitles'].split(',').to_a
    end

    client["names#{i}"].insert_many(names)
  end
end
