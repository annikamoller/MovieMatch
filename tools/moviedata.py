import tmdbsimple as tmdb
tmdb.API_KEY = '8f5d9aa6d322fb2cb6bc2dbbd24ab5a8'
# base URL for TMDB poster images
IMAGE_URL = 'https://image.tmdb.org/t/p/w500'
import csv
# from requests import HTTPError

movies = []

with open("ml-latest-small/movies.csv") as f:
    mreader = csv.reader(f)
    for row in mreader:
        print(row[0])
        row[2] = row[2].split("|")
        movies.append(row)

with open("ml-latest-small/links.csv") as f:
    lreader = csv.reader(f)
    i = 0
    for row in lreader:
        movies[i].append(row[2])
        i +=1

file = open("moviedb.rb", "w")
file.write("$movies = {")

for movie in movies:
    m = tmdb.Movies(movie[3])
    response = m.info()
    print(m.title)
    print(response['poster_path'])
    poster = ""
    if response['poster_path'] is not None:
        poster =  IMAGE_URL + response['poster_path']
    
    file.write("{} => Movie.new({},'{}','{}', '{}','{}', [{}]) \n".format(movie[3], movie[3], movie[1], poster, response['overview'].replace("'", ""), response['vote_average'], ",".join(['"' + m + '"' for m in movie[2]])))

file.write("} \n")