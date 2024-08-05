--#  Employee Analysis:
--Who is the senior most employee based on job title?
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1

-- Total spending by each Sales Support Agent
SELECT e.employee_id, 
       SUM(i.total) AS total_spending
FROM employee e
JOIN customer c ON CAST(c.support_rep_id AS VARCHAR) = CAST(e.employee_id AS VARCHAR)
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY e.employee_id
ORDER BY total_spending DESC;

--# Customer Behaviour Analysis:
--Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;

--Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT * FROM invoice
SELECT SUM(total) AS invoice_total, billing_city FROM invoice GROUP BY billing_city
ORDER BY invoice_total DESC

--Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
SELECT * FROM customer
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1

--How many customers are there in each country?
SELECT c.country, 
       COUNT(DISTINCT c.customer_id) AS customer_count
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY customer_count DESC;

--Which countries have more than 10% of the total customers?
SELECT country, 
       COUNT(customer_id) AS customer_count
FROM customer 
GROUP BY country
HAVING COUNT(customer_id) > (
    SELECT 0.10 * SUM(subquery.customer_count)
    FROM (
        SELECT country, 
               COUNT(customer_id) AS customer_count
        FROM customer 
        GROUP BY country 
    ) AS subquery
)
ORDER BY customer_count DESC;

--What is the average spending per customer?
SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       ROUND(AVG(i.total)::numeric, 2) AS avg_spend
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY avg_spend DESC;

--How does the average spending per customer vary between different countries?
SELECT c.country, 
       ROUND(AVG(i.total)::numeric, 2) AS avg_spend
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY avg_spend DESC;
 
--# Sales and Revenue Analysis:
--Which country has the highest total sales?
SELECT billing_country AS country, 
       ROUND(SUM(total)::numeric, 2) AS sales
FROM invoice
GROUP BY billing_country
ORDER BY sales DESC
LIMIT 1;

--What is the most popular genre in a specific country? — USA
SELECT g.name AS genre, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice i 
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA' 
GROUP BY g.name
ORDER BY total_sales DESC
LIMIT 1;

--How does the sales performance of rock music compare between the USA and Canada?
SELECT i.billing_country AS country, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice i 
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY i.billing_country
HAVING i.billing_country = 'Canada' OR i.billing_country = 'USA'
ORDER BY total_sales DESC;

--Which countries have the most invoices?
SELECT billing_country, COUNT(*) AS c FROM invoice GROUP BY billing_country ORDER BY c DESC

--What is the most popular music genre in each country?
WITH GenreSales AS (
    SELECT i.billing_country AS country, 
           g.name AS genre, 
           ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
),
RankedGenres AS (
    SELECT country, 
           genre, 
           total_sales,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_sales DESC) AS rank
    FROM GenreSales
)
SELECT country, 
       genre AS most_popular_genre, 
       total_sales
FROM RankedGenres
WHERE rank = 1
ORDER BY total_sales DESC;

--What is the total sales for each genre? This query calculates the total sales for each genre, rounding the result to two decimal places. The results are sorted by total sales in descending order.
SELECT g.name AS genre, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_sales DESC;

--Which genres have sales greater than the average?
--Using a CTE:
WITH GenreSales AS (
    SELECT g.name AS genre, 
           ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
    FROM invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY g.name
),
AverageSales AS (
    SELECT ROUND(AVG(total_sales)::numeric, 2) AS avg_sales
    FROM GenreSales
)
SELECT genre, total_sales
FROM GenreSales
WHERE total_sales > (SELECT avg_sales FROM AverageSales)
ORDER BY total_sales DESC;

--Using a Subquery:
SELECT g.name AS genre, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name
HAVING ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) > (
    SELECT ROUND(AVG(total_sales)::numeric, 2) 
    FROM (
        SELECT ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
        FROM invoice_line il
        JOIN track t ON il.track_id = t.track_id
        JOIN genre g ON t.genre_id = g.genre_id
        GROUP BY g.name
    ) subquery
)
ORDER BY total_sales DESC;

-- Calculate average sales for each genre
SELECT g.name AS genre, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_sales DESC;

-- Calculate and display the average sales across all genres
WITH GenreSales AS (
    SELECT g.name AS genre, 
           ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
    FROM invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY g.name
)
SELECT ROUND(AVG(total_sales)::numeric, 2) AS average_sales
FROM GenreSales;

--Show table of total_sales and average_sales in the same table 
WITH GenreSales AS (
    SELECT g.name AS genre, 
           ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
    FROM invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY g.name
),
AverageSales AS (
    SELECT ROUND(AVG(total_sales)::numeric, 2) AS avg_sales
    FROM GenreSales
)
SELECT genre, 
       total_sales,
       (SELECT avg_sales FROM AverageSales) AS average_sales
FROM GenreSales
ORDER BY total_sales DESC;

-- What are top10-selling tracks?
SELECT t.name AS track, 
       COUNT(il.track_id) AS number_purchased
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
GROUP BY t.name
ORDER BY number_purchased DESC
LIMIT 10;

-- What are the top10 popular countries for music purchases?
SELECT c.country AS country,
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN customer c ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_sales DESC
LIMIT 10;

--How does the monthly sales data vary?
SELECT EXTRACT(MONTH FROM invoice_date) AS month, 
       ROUND(SUM(total)::numeric, 2) AS sales
FROM invoice
GROUP BY EXTRACT(MONTH FROM invoice_date)
ORDER BY month;

--Which countries have the most Invoices?
SELECT * FROM invoice
SELECT billing_country, COUNT(*) AS c FROM invoice GROUP BY billing_country ORDER BY c DESC

-- What are the top 3 values of the total invoice?
SELECT * FROM invoice ORDER BY total DESC	
SELECT total FROM invoice ORDER BY total DESC LIMIT 3

--# Playlists Analysis:
--Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
    SELECT track_id FROM track
    JOIN genre ON track.genre_id = genre.genre_id
    WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT * FROM track
SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

--Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track)
ORDER BY milliseconds DESC;

SELECT AVG(milliseconds) AS avg_track_length
FROM track

SELECT name, milliseconds
FROM track
WHERE milliseconds > 393599
ORDER BY milliseconds DESC;

--# Genre and Artist Popularity:
--We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

-- Retrieve the artist's name and the names of all tracks in each album
SELECT a.Name AS Artist_Name, 
       al.Title AS Album_Name, 
       t.Name AS Track_Name
FROM Artist a
JOIN Album al ON a.Artist_ID = al.Artist_ID
JOIN Track t ON al.Album_ID = t.Album_ID;

--Which are the top 5 selling genres based on total sales?
SELECT g.name AS genre, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_sales DESC
LIMIT 5;

--Which artist has the highest total sales?
SELECT a.name AS artist_name, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY a.name
ORDER BY total_sales DESC
LIMIT 1;

--Which genre has the most number of tracks?
SELECT g.name as genre, COUNT(t.track_id) AS track_count
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
GROUP BY genre
ORDER BY track_count DESC;

--Who are the top3 artists in the “Rock” genre based on total sales?
SELECT a.name AS artist_name, 
       ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS total_sales
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN album al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
WHERE g.name = 'Rock'
GROUP BY a.name
ORDER BY total_sales DESC
LIMIT 3;
