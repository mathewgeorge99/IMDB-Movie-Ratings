USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    table_name, 
    table_rows 
FROM 
    information_schema.tables 
WHERE 
    table_schema = 'imdb' 
    AND table_name IN ('director_mapping', 'genre', 'movie', 'names', 'ratings', 'role_mapping')
ORDER BY 
    table_rows DESC;







-- Q2. Which columns in the movie table have null values?
select column_name from information_schema.columns where table_name='movie' and table_schema='imdb'
and is_nullable='YES';
select count(*) from movie where movie.id is null or movie.title is null
or movie.year is null or movie.date_published is null or movie.duration is null
or movie.duration is null or movie.country is null or movie.worldwide_gross_income is null
or movie.languages is null;

select * from movie where id is null or title is null or
date_published is null or duration is null or country is null
or languages is null or production_company is null or movie.year is null  or
worlwide_gross_income is null;




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
select 
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
#Movies produced per year
select movie.year,count(movie.id) as 'number of movies'from movie group by movie.year;

#Monthly wise trend for year 2017

SELECT movie.year,cast(substr(DATE_FORMAT(date_published, '%Y-%m'),6)AS unsigned) AS production_month, COUNT(id) AS 'number of movies'
FROM movie 
WHERE year LIKE '%2017%' 
GROUP BY production_month, year order by production_month ASC ;

#Monthly wise trend for year 2018

SELECT movie.year,cast(substr(DATE_FORMAT(date_published, '%Y-%m'),6)AS unsigned) AS production_month, COUNT(id) AS 'number of movies'
FROM movie 
WHERE year LIKE '%2018%' 
GROUP BY production_month, year order by production_month ASC ;

#Monthly wise trend for year 2019

SELECT movie.year,cast(substr(DATE_FORMAT(date_published, '%Y-%m'),6)AS unsigned) AS production_month, COUNT(id) AS 'number of movies'
FROM movie 
WHERE year LIKE '%2019%' 
GROUP BY production_month, year order by production_month ASC ;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(movie.id),movie.country,movie.year from movie where 
(country='India'or country='USA') and movie.year like'%2019%'
  group by movie.country;


select count(movie.id),movie.country,movie.year from movie where 
movie.country like '%India%' or movie.country like '%USA%' and movie.year like'%2019%'
GROUP BY movie.country;

SELECT COUNT(movie.id) AS 'Number of movies'
FROM movie
WHERE (country = 'USA' or country='India') AND YEAR='2019';




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select genre.genre from genre group by genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre.genre,count(genre.movie_id) as movies from genre
group by genre.genre order by movies desc;

# Drama genre has the highest number of movies produced







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS number_of_movies
FROM (SELECT movie_id FROM genre GROUP BY movie_id HAVING COUNT(*) = 1) 
AS single_genre_movies;











/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre.genre,avg(movie.duration) as average_duration from genre join movie
on movie.id=genre.movie_id group by genre.genre order by average_duration desc;







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, COUNT(movie_id) AS number_of_movies,
       (SELECT COUNT(DISTINCT genre) FROM genre) - RANK() OVER (ORDER BY COUNT(movie_id) DESC) + 1 AS genre_rank
FROM genre
GROUP BY genre
HAVING genre = 'Thriller';




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:


select * from ratings;

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
#Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

select min(ratings.avg_rating) as min_avg_rating,max(ratings.avg_rating) as max_avg_rating,
min(ratings.total_votes) as min_total_votes,
max(ratings.total_votes) as max_total_votes,
min(ratings.total_votes) as min_total_votes from ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT movie.title, ratings.avg_rating,
DENSE_RANK() OVER (ORDER BY ratings.avg_rating DESC) AS 'RANK'
FROM ratings JOIN movie ON movie.id=ratings.movie_id 
ORDER BY ratings.avg_rating DESC LIMIT 40;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


select ratings.median_rating,count(ratings.movie_id) as movie_count from ratings
group by ratings.median_rating order by median_rating desc;







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.production_company, 
    COUNT(m.id) AS movie_count, 
    (SELECT 
         COUNT(*) + 1 
     FROM 
         (SELECT 
              m2.production_company, 
              COUNT(m2.id) AS movie_count 
          FROM 
              movie m2 
              INNER JOIN ratings r2 ON m2.id = r2.movie_id 
          WHERE 
              r2.avg_rating > 8 AND m2.production_company IS NOT NULL 
          GROUP BY 
              m2.production_company
         ) t 
     WHERE 
         t.movie_count > COUNT(m.id)
    ) AS prod_company_rank
FROM 
    movie m 
    INNER JOIN ratings r ON m.id = r.movie_id 
WHERE 
    r.avg_rating > 8 AND m.production_company IS NOT NULL 
GROUP BY 
    m.production_company 
ORDER BY 
    movie_count DESC;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    genre,
    COUNT(*) AS movie_count
FROM (
    SELECT
        g.genre,
        m.id
    FROM
        genre g
        INNER JOIN movie m ON m.id = g.movie_id
        INNER JOIN ratings r ON m.id = r.movie_id
    WHERE
        m.year = 2017
        AND MONTH(m.date_published) = 3
        AND m.country LIKE '%USA%'
        AND r.total_votes > 1000
) subquery
GROUP BY genre
ORDER BY movie_count DESC;








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
  m.title, 
  r.avg_rating, 
  GROUP_CONCAT(DISTINCT g.genre SEPARATOR ', ') AS genre
FROM 
  movie m 
  JOIN ratings r ON m.id = r.movie_id 
  JOIN genre g ON m.id = g.movie_id 
WHERE 
  m.title LIKE 'The%' AND r.avg_rating > 8 
GROUP BY 
  m.title 
ORDER BY 
  r.avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
    COUNT(m.id) AS movie_released,
    AVG(r.median_rating) AS median_rating
FROM
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE
    r.median_rating = 8
    AND m.date_published >= '2018-04-01'
    AND m.date_published < '2019-04-01';







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    m.country, 
    SUM(r.total_votes) AS votes_count
FROM 
    movie m
    JOIN ratings r ON m.id = r.movie_id
WHERE 
    m.country IN ('germany', 'italy')
GROUP BY 
    m.country;






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
  COUNT(*) - COUNT(name) AS name_nulls,
  COUNT(*) - COUNT(height) AS height_nulls,
  COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
  COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres AS (
  SELECT genre
  FROM genre g
  INNER JOIN ratings r ON g.movie_id = r.movie_id
  WHERE r.avg_rating > 8
  GROUP BY genre
  ORDER BY COUNT(*) DESC
  LIMIT 3
), 
top_directors AS (
  SELECT n.name as director_name, COUNT(*) as movie_count
  FROM names n
  INNER JOIN director_mapping d ON n.id = d.name_id
  INNER JOIN genre g ON g.movie_id = d.movie_id
  INNER JOIN ratings r ON r.movie_id = d.movie_id
  WHERE r.avg_rating > 8 AND g.genre IN (SELECT genre FROM top_genres)
  GROUP BY n.id
  ORDER BY COUNT(*) DESC
  LIMIT 3
)
SELECT director_name, movie_count
FROM top_directors LIMIT 3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT
n.name AS actor_name,
COUNT(DISTINCT rm.movie_id) AS movie_count
FROM role_mapping rm
INNER JOIN names n
ON n.id = rm.name_id
WHERE category="actor" AND rm.movie_id IN (
    SELECT movie_id FROM ratings WHERE median_rating >= 8
)
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
    t1.production_company,
    t1.vote_count,
    DENSE_RANK() OVER(ORDER BY t1.vote_count DESC) AS prod_comp_rank
FROM 
    (
    SELECT 
        m.production_company, 
        SUM(r.total_votes) as vote_count
    FROM 
        movie m 
        INNER JOIN ratings r 
        ON m.id = r.movie_id 
    GROUP BY 
        m.production_company
    ) AS t1 
ORDER BY 
    vote_count DESC 
LIMIT 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_movie_counts AS (
  SELECT 
    rm.name_id,
    COUNT(rm.movie_id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    ROUND(SUM(r.avg_rating + r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating
  FROM role_mapping rm
  INNER JOIN ratings r ON rm.movie_id = r.movie_id
  INNER JOIN movie m ON r.movie_id = m.id
  WHERE rm.category = 'actor' AND m.country = 'India'
  GROUP BY rm.name_id
  HAVING COUNT(rm.movie_id) >= 5
), ranked_actor_stats AS (
  SELECT 
    n.name AS actor_name,
    amc.total_votes,
    amc.movie_count,
    amc.actor_avg_rating,
    RANK() OVER(ORDER BY amc.actor_avg_rating DESC) AS actor_rank
  FROM actor_movie_counts amc
  INNER JOIN names n ON amc.name_id = n.id
)
SELECT * FROM ranked_actor_stats
ORDER BY actor_rank;









-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:










/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
  title,
  avg_rating,
  CASE 
    WHEN avg_rating > 8 THEN 'Superhit movies'
    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
    ELSE 'Flop Movies'
  END AS avg_rating_category
FROM (
  SELECT 
    m.title,
    AVG(r.avg_rating) AS avg_rating
  FROM movie m
  JOIN ratings r
    ON m.id = r.movie_id
  JOIN genre g
    ON m.id = g.movie_id
  WHERE g.genre = 'thriller'
  GROUP BY m.title
) subquery;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration AS (
  SELECT
    genre,
    AVG(duration) AS avg_duration,
    ROW_NUMBER() OVER (PARTITION BY genre ORDER BY genre) AS rn
  FROM
    movie m
    JOIN genre g ON m.id = g.movie_id
  GROUP BY
    genre
)

SELECT
  gd1.genre,
  ROUND(gd1.avg_duration, 2) AS avg_duration,
  SUM(gd2.avg_duration) AS running_total_duration,
  AVG(gd1.avg_duration) OVER (ORDER BY gd1.rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM
  genre_duration gd1
  JOIN genre_duration gd2 ON gd1.rn >= gd2.rn AND gd1.genre = gd2.genre
GROUP BY
  gd1.genre,
  gd1.avg_duration,
  gd1.rn
ORDER BY
  gd1.genre









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
















-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    production_company, 
    COUNT(DISTINCT m.id) as movie_count, 
    DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT m.id) DESC) as prod_comp_rank
FROM 
    movie m
INNER JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    median_rating >= 8
    AND production_company IS NOT NULL
    AND languages LIKE '%,%'
GROUP BY 
    production_company
LIMIT 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:









/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH director_movies AS (
  SELECT d.name_id, n.NAME, d.movie_id, m.duration, r.avg_rating, r.total_votes, m.date_published
  FROM director_mapping d
  JOIN names n ON d.name_id = n.id
  JOIN movie m ON d.movie_id = m.id
  JOIN ratings r ON m.id = r.movie_id
), director_movies_lag AS (
  SELECT name_id, NAME, movie_id, duration, avg_rating, total_votes, date_published,
    LEAD(date_published) OVER(PARTITION BY name_id ORDER BY date_published, movie_id) AS next_date_published
  FROM director_movies
), director_movie_stats AS (
  SELECT name_id, NAME, COUNT(movie_id) AS number_of_movies, 
         ROUND(AVG(DATEDIFF(next_date_published, date_published)), 2) AS avg_inter_movie_days,
         ROUND(AVG(avg_rating), 2) AS avg_rating,
         SUM(total_votes) AS total_votes,
         MIN(avg_rating) AS min_rating,
         MAX(avg_rating) AS max_rating,
         SUM(duration) AS total_duration
  FROM director_movies_lag
  GROUP BY name_id, NAME
)
SELECT director_id, director_name, number_of_movies, avg_inter_movie_days, 
       avg_rating, total_votes, min_rating, max_rating, total_duration
FROM (
  SELECT name_id AS director_id, NAME AS director_name, number_of_movies, 
         avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration,
         RANK() OVER(ORDER BY number_of_movies DESC) AS director_rank
  FROM director_movie_stats
) ranked_director_stats
WHERE director_rank <= 9
ORDER BY director_rank;





