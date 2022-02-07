# frozen_string_literal: true

require 'csv'
require 'json'

desc 'Push to cloud'

task :last_db_try do
  client = Mongo::Client.new('mongodb+srv://dbUser:Xm!4NU$X*TkWEKe@cluster0.cat4j.mongodb.net/film_shelf_production?retryWrites=true&w=majority')

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
