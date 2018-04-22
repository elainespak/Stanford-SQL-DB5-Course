# Q1: Find the names of all students who are friends with someone named Gabriel. 

SELECT name
FROM (SELECT ID2 as ID
FROM Friend
WHERE ID1 in (SELECT ID FROM Highschooler WHERE name = "Gabriel")) LEFT JOIN Highschooler using(ID)


# Q2: For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 

SELECT n, g, name as n2, grade as g2
FROM (SELECT name as n, grade as g, ID2 FROM Likes, Highschooler as h WHERE ID1 = h.ID), Highschooler as h2
WHERE ID2 = h2.ID AND g - g2 >= 2


# Q3: For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 

SELECT h.name, h.grade, h2.name, h2.grade
FROM (SELECT l.ID1, l.ID2
FROM Likes as l, Likes as l2
WHERE l.ID1 = l2.ID2 AND l.ID2 = l2.ID1), Highschooler as h, Highschooler as h2
WHERE ID1 = h.ID AND ID2 = h2.ID AND h.name < h2.name
ORDER BY h.name


# Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 

SELECT name, grade
FROM Highschooler
WHERE ID not in (SELECT ID1 FROM Likes) AND ID not in (SELECT ID2 FROM Likes)


# Q5: For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 

SELECT h.name, h.grade, h2.name, h2.grade
FROM (SELECT * FROM Likes WHERE ID2 not in (SELECT ID1 FROM Likes)), Highschooler as h, Highschooler as h2
WHERE ID1 = h.ID AND ID2 = h2.ID


# Q6: Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT name, grade
FROM Highschooler
WHERE ID NOT IN
(SELECT ID1
FROM Friend F1 JOIN Highschooler H1
ON H1.ID = F1.ID1
JOIN Highschooler H2
ON H2.ID = F1.ID2
WHERE H1.grade <> H2.grade)
ORDER BY grade, name


# Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

SELECT H.name, H.grade, H2.name, H2.grade, H3.name, H3.grade
FROM (SELECT F2.ID1, F.ID2, F.ID1 AS ID3
FROM Friend F LEFT JOIN Friend F2 ON F.ID1 = F2.ID2, Likes L
WHERE F.ID2 < F2.ID1
AND L.ID2 NOT IN (SELECT F3.ID2 FROM Friend F3 WHERE L.ID1 = F3.ID1)
AND ((L.ID1 = F.ID2 AND L.ID2 = F2.ID1) OR (L.ID1 = F2.ID1 AND L.ID2 = F.ID2))) C
LEFT JOIN Highschooler H ON C.ID1 = H.ID
LEFT JOIN Highschooler H2 ON C.ID2 = H2.ID
LEFT JOIN Highschooler H3 ON C.ID3 = H3.ID
ORDER BY H.name, H2.name


# Q8: Find the difference between the number of students in the school and the number of different first names. 

SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler


# Q9: Find the name and grade of all students who are liked by more than one other student. 

SELECT name, grade
FROM (SELECT *, COUNT(*) AS C FROM Likes GROUP BY ID2) JOIN Highschooler ON ID2 = Highschooler.ID
WHERE C > 1