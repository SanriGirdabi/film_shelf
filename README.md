# film_shelf

This is a test project that uses [IMDB data](https://datasets.imdbws.com/) with the [Ruby](https://tr.reactjs.org/), [Rails](https://www.apollographql.com/) API only version for the backend. You can search with at least 4 characters (case-sensitive) and at least 3 character (case-sensitive) for movies and the casts respectively. You can also sign-up and add some movies, genres or the casts to your favorites. To do that you need to sign-in otherwise all you can do is just searching. The project uses [MongoDB](https://www.mongodb.com/) database and you can reach the Frontend app from [here](https://github.com/eypsrcnuygr/FILM_SHELF_FRONTEND).

## Built With

- Ruby
- Rails API
- GraphQL
- MongoDB

## Prerequisities

- To get this project up and running locally, you must already have ruby installed on your computer.
- To run the local database server and connect the  Ruby-driver to the server you need to install [mongod](https://docs.mongodb.com/v4.0/administration/install-community/) on your computer. Please refer the link before continue.

## Live Link

I tried to host on Mongo Atlas but the free membership is limited to 500 MB and it is not enough for this data. Also I tried a lot but couldn't find a solution for ```mongoid.yml``` to see the host option for remote server. I'll try in the future and will share the conclusion here.


## Getting Started

**Setup**

- Clone this repository with ```git clone https://github.com/eypsrcnuygr/film_shelf``` using your terminal or command line.<br>
- Change to the project directory by entering ```cd film_shelf``` in the terminal<br>
- Open two different terminal more.
- At one terminal run ```ulimit -n 4096```. This gives more memory before continueing the db creation processes. [Here](https://stackoverflow.com/questions/20931909/too-many-open-files-while-ensure-index-mongo) you can read about the maximum open files issue on StackOverFlow.
- Next run ```mongod --dbpath /Users/$your_user_name/Documents/local_datas/mongo_db/data --logpath /Users/$your_user_name/Documents/local_datas/mongo_db/logs/mongo.log``` to start the mongo server. You can also change the paths, if you wish!<br>
- At the other terminal run ```mongo``` to start the mongo shell. It's not mandatory but I like to see and manipulate the database from the shell.<br>
- Then at the first terminal inside the API folder (/film_shelf), run ```bundle```to install the necessary gems.<br>
- Wait for bundle to finish.<br>
- Then run ```rails s``` to start the application server.
- From the [IMDB data](https://datasets.imdbws.com/) please download the ```name.basics.tsv.gz``` and ```title.basics.tsv.gz``` and unzipped them.
- Then open another terminal and change the directory to the unzipped files directory and run```split -l 25000 title.basics.tsv```. This command will split the tsv file into 25.000 line and create these files. 
- On the same terminal then run```for i in *; do mv "$i" "$i.tsv"; done```. This command will add tsv file type as post-fix to the files. Collect and put them inside the public folder under the name ```title_tsvs```.<br> (```/film_shelf/public/title_tsvs```)
- On the same terminal and run```split -l 25000 name.basics.tsv```. This command will split the tsv file into 25.000 line and create these files.
- On the same terminal then run```for i in *; do mv "$i" "$i.tsv"; done```. This command will add tsv file type as post-fix to the files. Collect and put them inside the public folder under the name ```name_tsvs```.<br> (```/film_shelf/public/name_tsvs```)
- You can  change the terminal directory to the apps directory.
- As you can see there are four rake tasks added. We'll use 3 of them. In the terminal run ```rake convert_titles```, ```rake convert_names```respectively. These will create json files from the tsv files and store them inside the public folder. We'll need them for our [MongoDB](https://www.mongodb.com/) database.
- Then run ```rake db_creator_custom```. This rake task has two options, I have used both of them. If you wish to have the time-stamps for your records don't change anything in the task, but it'll take more storage from your computer and takes more than 1 day to finish the task. If you don't care about the time-stamps switch the commented and uncommented parts. The task should look like this, you can copy from here and paste into the ```db_creator.rake``` file;<br>
``` 
require 'csv'
require 'json'

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
 ```
- If you choose to work with the second option it'll take around half an hour.
- After the task is finished you are all good and ready to go.
- Enjoy!<br>

**Repository Content**

- It is a default [Rails app](https://rubyonrails.org/) with API only option, configured without [Active Record](https://guides.rubyonrails.org/active_record_basics.html).
- It also uses [GraphQL](https://graphql.org/) query language to talk with the [Frontend](https://github.com/eypsrcnuygr/FILM_SHELF_FRONTEND) with just one endpoint.

## Authors

👤 **Eyüp Sercan UYGUR**

-   Github: [@eypsrcnuygr](https://github.com/eypsrcnuygr)
-   Twitter: [@eypsrcnuygr](https://twitter.com/eypsrcnuygr)
-   LinkedIn: [eypsrcnuygr](https://www.linkedin.com/in/eypsrcnuygr/)
-   Email: [Eyüp Sercan UYGUR](sercanuygur@gmail.com)

## 🤝 Further Words and Future Improvements

- If I find time, I'm thinking to cover more edge cases and error handling on the Backend.
- Better loggin-in and current_user tracing would be nice. For every session a seperated ```logged_in``` boolean could be the next step.
- My relations and the app causes a lot of queries, so maybe embedding ```titles``` and the ```names``` collections could be an approach. However in my mind, there is a ```sharding```option, which needs better indexing so I'm leaving it later.

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

## Show your support

Give a ⭐️ if you like this project!


## 📝 License

This project is [MIT](https://github.com/git/git-scm.com/blob/master/MIT-LICENSE.txt) licensed.
