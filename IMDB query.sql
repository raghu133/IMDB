use imdb;
select * from director_mapping;
select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping;

#Queries to be Performed

#1. Count the total number of records in each table of the database.
select(select count(name_id) from director_mapping) as director_mapping ,
(select count(movie_id) from genre) as  genre ,
(select count(id) from  movie) as movie ,
(select count(movie_id) from ratings) as ratings ,
(select count(name_id) from role_mapping) as role_mapping,
count(id )from names as names ;

#2. Identify which columns in the movie table contain null values.
select 'worlwide_gross_income',count(*) as nullvalue
from movie
where worlwide_gross_income is null
union all
select 'id',count(*) 
from movie
where id is null
union all
select 'title',count(*) 
from movie
where title is null
union all
select 'year',count(*) 
from movie
where year is null
union all
select'languages',count(*) 
from movie
where languages is null
union all
select 'production_company',count(*) 
from movie
where production_company is null
union all
select'duration' ,count(*) 
from movie
where duration is null
union all
select 'date_published', count(*) 
from movie
where date_published is null
union all
select 'country', count(*) 
from movie
where country is null;


#3. Determine the total number of movies released each year, and analyze how the trend changes month-wise.
select year,count(title)
from movie
group by year;
select month(date_published),count(title)
from movie
group by month(date_published)
order by month(date_published) asc;
#4. How many movies were produced in either the USA or India in the year 2019?
select count(id)
from (select * from movie where year=2019) AS YEAR2019
where country IN('usa','india');

#5. List the unique genres in the dataset, and count how many movies belong exclusively to one genre.
select distinct genre
FROM genre; 
select count(movie_id ) as movies_belong_exclusively_to_one_genre
from( select movie_id,count(genre) AS QW
from genre
group by movie_id) as qr
where  QW=1;

#6. Which genre has the highest total number of movies produced?
select genre,count(movie_id) AS highest_total
from genre
group by genre
Order by highest_total desc
limit 1;

#7. Calculate the average movie duration for each genre.
select genre,avg(duration) AS average_movie_duration
from genre
join movie
on genre.movie_id=movie.id
group by genre;
#8. Identify actors or actresses who have appeared in more than three movies with an average rating below 5.
select category,name_id,count(movie_id) AS movie_count
from(
select role_mapping.movie_id,role_mapping.name_id,role_mapping.category,ratings.avg_rating
from role_mapping
join ratings
on role_mapping.movie_id=ratings.movie_id
where avg_rating <5) as qw
group by name_id,category
having  movie_count>3;

#9. Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column.
select max(avg_rating),min(avg_rating),max(total_votes),min(total_votes),max(median_rating),min(median_rating)
from ratings;

#10. Which are the top 10 movies based on their average rating?
select movie_id,avg_rating
from ratings
order by avg_rating desc
limit 10;

#11. Summarize the ratings table by grouping movies based on their median ratings.
select median_rating,count(movie_id) as movie_count,avg(avg_rating) as avg_rating
from ratings
group by median_rating 
order by median_rating;

#12. How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes?
select genre.genre,count(genre.movie_id)
FROM (select id,date_published,country
from movie
where date_published between '2017-03-01' and '2017-03-31'and country='USA') AS MN
JOIN genre on  MN.id=genre.movie_id
join ratings on mn.id=ratings.movie_id
where total_votes>1000
group by genre.genre;

#13. Find movies from each genre that begin with the word “The” and have an average rating greater than 8.
select genre.genre,movie.title,ratings.avg_rating
from movie
join genre
on genre.movie_id=movie.id
join ratings 
on movie.id=ratings.movie_id
where movie.title like"the %" and ratings.avg_rating>8;
#14. Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8?
select movie.date_published,ratings.avg_rating
from movie
join ratings
on movie.id=ratings.movie_id
where date_published between '2018-04-01' and '2019-04-01' and avg_rating=8;
#15. Do German movies receive more votes on average than Italian movies?
select 'German',avg(total_votes) as average
from(SELECT movie.languages,ratings.total_votes
FROM movie
join ratings  
ON  movie.id=ratings.movie_id
where  movie.languages like '%German%') as gh
union
select 'italian',avg(total_votes)as average
from(SELECT movie.languages,ratings.total_votes
FROM movie
join ratings  
ON  movie.id=ratings.movie_id
where languages like '%italian%') as hj;

#16. Identify the columns in the names table that contain null values.
select 'id',count(*) 
from names
where id is null
union all
select 'name',count(*) 
from  names
where name is null
union all
select 'height',count(*) 
from names
where height is null
union all
select 'date_of_birth',count(*) 
from names
where date_of_birth is null
union all
select 'known_for_movies',count(*) 
from names
where known_for_movies is null;

#17. Who are the top two actors whose movies have a median rating of 8 or higher?
select names.name,ratings.median_rating,role_mapping.category
from role_mapping
join names
on names.id=role_mapping.name_id
join ratings
on role_mapping.movie_id=ratings.movie_id
where median_rating >=8 and category='actor'
order by median_rating desc
limit 2;

#18. Which are the top three production companies based on the total number of votes their movies received?
select movie.production_company,sum(ratings.total_votes)
from movie
join ratings
on movie.id=ratings.movie_id
group by movie.production_company
order by sum(ratings.total_votes) desc
limit 3;
#19. How many directors have worked on more than three movies?
select distinct name_id,count(movie_id) 
from director_mapping
group by name_id
having count(movie_id)>3;
#20. Calculate the average height of actors and actresses separately.
select distinct role_mapping.category,avg(names.height) AS average_height
from names
join role_mapping
on role_mapping.name_id=names.id
group by role_mapping.category;
#21. List the 10 soldest movies in the dataset along with their title, country, and director.
select movie.title, movie.country,movie.date_published,names.name
from role_mapping
join movie
on role_mapping.movie_id=movie.id
join names
on names.id=role_mapping.name_id
order by date_published asc
limit 10;
#22. List the top 5 movies with the highest total votes, along with their genres.
select distinct movie.title,genre.genre,ratings.total_votes
from genre
join movie
on genre.movie_id=movie.id
join ratings
on genre.movie_id=ratings.movie_id
order by total_votes desc
limit 5;

#23. Identify the movie with the longest duration, along with its genre and production company.
select movie.production_company,genre.genre, movie.duration
from movie
join genre
on movie.id=genre.movie_id
order by duration desc
limit 1;
#24. Determine the total number of votes for each movie released in 2018.
select sum(total_votes)
from (select movie.title, movie.year,ratings.total_votes
from movie
join ratings
on movie.id=ratings.movie_id
where year='2018') as mn;

#25. What is the most common language in which movies were produced?
select languages,count(title)
from movie 
group by languages
order by count(title) desc
limit 1;


