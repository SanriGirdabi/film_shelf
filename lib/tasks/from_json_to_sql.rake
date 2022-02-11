# frozen_string_literal: true

desc 'Create sql file from json files'

task from_json_to_sql: :environment do
  (0..332).each do |i|
    titles = JSON.parse(File.read("#{Dir.pwd}/public/title_jsons/title#{i}.json"))
    titles.map do |title_hash|
      Movie.create!(tconst: title_hash['tconst'], title_type: title_hash['titleType'],
                    primary_title: title_hash['primaryTitle'], original_title: title_hash['originalTitle'], is_adult: title_hash['isAdult'], start_year: title_hash['startYear'], end_year: title_hash['endYear'], runtime_minutes: title_hash['runtimeMinutes'], genres: title_hash['genres'].split(','))
    end
  end

  (0..450).each do |i|
    names = JSON.parse(File.read("#{Dir.pwd}/public/name_jsons/name#{i}.json"))
    names.map do |name_hash|
      Actor.create!(nconst: name_hash['nconst'], primary_name: name_hash['primaryName'],
                    birth_year: name_hash['birthYear'], death_year: name_hash['deathYear'], primary_profession: name_hash['primaryProfession'].split(','), known_for_titles: name_hash['knownForTitles'].split(','))
    end
  end
end
