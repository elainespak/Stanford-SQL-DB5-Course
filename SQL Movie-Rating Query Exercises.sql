# Q1: Find the titles of all movies directed by Steven Spielberg. 

select title
from Movie
where director = "Steven Spielberg";


# Q2: Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct (year)
from Rating, Movie
where Rating.mID = Movie.mID and stars >= 4
order by year;


# Q3: Find the titles of all movies that have no ratings. 

select title
from Movie
where Movie.mID not in (select mID from Rating);


# Q4: Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

select distinct(name)
from Reviewer, Rating
where Reviewer.rID in (select rID from Rating where ratingDate is null);


# Q5: Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select name, title, stars, ratingDate
from (Rating left join Movie using (mID)) left join Reviewer using (rID)
order by name, title, stars;


# Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

SELECT name, title
FROM Reviewer, Movie
WHERE Reviewer.rID = 
(SELECT rID
FROM Rating R
WHERE R.stars < (SELECT stars FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2)
and
R.ratingDate < (SELECT ratingDate FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2)
and
R.rID = (SELECT rID FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2))
and
Movie.mID =
(SELECT mID
FROM Rating R
WHERE R.stars < (SELECT stars FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2)
and
R.ratingDate < (SELECT ratingDate FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2)
and
R.rID = (SELECT rID FROM (SELECT *, count(*) as c FROM Rating GROUP BY rID, mID) WHERE c = 2))


# Q7: For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select distinct title, stars
from (select * from Rating
where stars = (select MAX(stars) from Rating as R2 where Rating.mID = R2.mID)) left join Movie
using(mID)
order by title


#Q8: For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

SELECT distinct m1.title, (m1.stars - m2.stars) as dif
FROM (select * from Rating R0 left join Movie using(mID)
where stars= (select MAX(stars) from Rating as R1 where R0.mID = R1.mID)) as m1,
(select * from Rating R0 left join Movie using(mID)
where stars= (select MIN(stars) from Rating as R2 where R0.mID = R2.mID)) as m2
WHERE m1.mID = m2.mID
order by dif desc, m1.title;


# Q9: Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

SELECT AVG(oldstars) - AVG(newstars)
FROM (SELECT mID, year, AVG(stars) as oldstars FROM Rating LEFT JOIN Movie USING(mID) GROUP BY mID
HAVING year < 1980),
(SELECT mID, year, AVG(stars) as newstars FROM Rating LEFT JOIN Movie USING(mID) GROUP BY mID
HAVING year > 1980)