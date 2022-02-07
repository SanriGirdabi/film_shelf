# frozen_string_literal: true

require 'csv'
require 'json'

desc 'convert name tsv to json'

task :convert_names do
  first = (1..26).zip('a'..'z').to_h
  second = (1..26).zip('a'..'z').to_h

  header = CSV.open("#{Dir.pwd}/public/name.basics.tsv", &:readline)

  k = 0

  (1..26).each do |i|
    break if i == 19

    (1..26).each do |y|
      break if i == 18 && y == 10

      variable = CSV.open(
        "#{Dir.pwd}/public/name_tsvs/x#{first[i]}#{second[y]}.tsv",
        quote_char: '|'
      ).map do |item|
        item
      end

      array_of_keys = header.map { |element| element.split("\t") }.flatten

      array_of_values = []

      variable.each do |element|
        array_of_values.push([element.join(',').split("\t")])
      end

      def writable_object_creator(array_of_values, array_of_keys)
        title_obj = []
        array_of_values.flatten(1).each do |item|
          title_obj << Hash[array_of_keys.zip(item)]
        end
        title_obj
      end

      File.write("#{Dir.pwd}/public/name_jsons/name#{k}.json",
                 writable_object_creator(array_of_values, array_of_keys).to_json, mode: 'a')
      k += 1
    end
  end
end
