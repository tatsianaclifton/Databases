#CS340 Assignment 2
#Tatsiana Clifton

#1 Find the film title and language name of all films in which ADAM GRANT acted
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)

SELECT f.title AS film_title, l.name AS language_name FROM film f 
LEFT JOIN language l ON l.language_id = f.language_id
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON a.actor_id = fa.actor_id
WHERE a.first_name = 'ADAM' AND a.last_name = 'GRANT'
ORDER BY f.title DESC;


#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).

SELECT c.name AS category_name, COUNT(fc.film_id) AS count_films FROM category c
LEFT JOIN (
    SELECT fc.category_id, fc.film_id, a.actor_id FROM film_category fc
    INNER JOIN film f ON fc.film_id = f.film_id
    INNER JOIN film_actor fa ON fa.film_id = f.film_id
    INNER JOIN actor a ON a.actor_id = fa.actor_id
    WHERE a.first_name = 'ED' AND a.last_name = 'CHASE') AS fc
ON c.category_id = fc.category_id
GROUP BY c.name ASC;


#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT a.first_name AS actor_first_name, a.last_name AS actor_last_name, SUM(temp.length) AS Sci_Fi_length FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN (
    SELECT f.film_id, f.length FROM film f
    INNER JOIN film_category fc ON fc.film_id = f.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Sci-Fi') AS temp ON fa.film_id = temp.film_id  
GROUP BY a.actor_id;


#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT a.first_name AS actor_first_name, a.last_name AS actor_last_name FROM actor a 
WHERE a.actor_id NOT IN(
    SELECT a.actor_id FROM actor a
    INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
    INNER JOIN film f ON f.film_id = fa.film_id
    INNER JOIN film_category fc ON fc.film_id = f.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Sci-Fi');


#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT temp.title AS film_title FROM 
    (SELECT f.title, f.film_id FROM film f
    INNER JOIN film_actor fa ON fa.film_id = f.film_id
    INNER JOIN actor a ON a.actor_id = fa.actor_id
    WHERE a.first_name = "KIRSTEN" AND a.last_name = "PALTROW") AS temp
INNER JOIN(    
    SELECT f1.title, f1.film_id FROM film f1
    INNER JOIN film_actor fa1 ON fa1.film_id = f1.film_id
    INNER JOIN actor a1 ON a1.actor_id = fa1.actor_id
    WHERE a1.first_name = "WARREN" AND a1.last_name = "NOLTE") AS temp1
ON temp.film_id = temp1.film_id
ORDER BY temp.title DESC;       
     