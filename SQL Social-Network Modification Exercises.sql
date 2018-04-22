# Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 

DELETE FROM Highschooler
WHERE grade = 12


# Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

DELETE FROM Likes
WHERE Likes.ID2 NOT IN (SELECT L.ID1 FROM Likes L WHERE Likes.ID1 = L.ID2)
AND Likes.ID2 IN (SELECT F.ID2 FROM Friend F WHERE Likes.ID1 = F. ID1) 


# Q3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 

INSERT INTO Friend
(ID1, ID2)
SELECT F.ID2 AS ID1, F2.ID1 AS ID2
FROM Friend F LEFT JOIN Friend F2 ON F.ID1 = F2.ID2
WHERE F.ID2 <> F2.ID1
EXCEPT
SELECT * FROM Friend