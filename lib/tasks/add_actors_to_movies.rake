# frozen_string_literal: true

desc 'Create sql file from json files'

task add_actors_to_movies: :environment do
  (0..450).each do |i|
    names = JSON.parse(File.read("#{Dir.pwd}/public/name_jsons/name#{i}.json"))
    names.map do |name_hash|
      name_hash['knownForTitles'].split(',').each do |title_id|
        updated_record = Movie.find_by(tconst: title_id)
        updated_record.crew += [name_hash['nconst']] unless updated_record.nil?
        updated_record&.save
      end
    end
  end
end
