/*   Music Store Data Analysis Project using SQL   */


/*   SET-1(Easy)   */

/* 1. Who is the senior most employee based on job title? */

select last_name, first_name, title, levels from employee
order by levels desc
limit 1;


/* 2. Which countries have the most Invoices? */

select count(total) as most_invoices, billing_country from invoice
group by billing_country
order by most_invoices desc;


/* 3. What are top 3 values of total invoice? */

select total as top_values from invoice
order by top_values desc
limit 3;


/* 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city
we made the most money. Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice totals */

select sum(total) as invoice_totals, billing_city from invoice
group by billing_city
order by invoice_totals desc
limit 10;


/* 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money */

select customer.customer_id, customer.first_name, customer.last_name,
sum(invoice.total) as total_invoices from customer
join invoice on customer.customer_id = invoice.customer_id 
group by customer.customer_id
order by total_invoices desc
limit 1;



/*    SET-2(Moderate)    */

/* 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A. */

select distinct customer.email, customer.first_name, customer.last_name,
genre.name as genre_name FROM customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
order by email;


/* 2. Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands */


select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from artist
join album on album.artist_id = artist.artist_id 
join track on track.album_id = album.album_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;


/* 3. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with
the longest songs listed first */

select name,milliseconds from track
where milliseconds > (
	select avg(milliseconds) as avg_track_length
	from track )
order by milliseconds desc;



/*    SET-3(Advanced)    */


/* 1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent */

with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name, 
    sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by artist.artist_id
	order by total_sales desc
	limit 1
)

select customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer on customer.customer_id = invoice.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join best_selling_artist on best_selling_artist.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc;


/* 2. We want to find out the most popular music Genre for each country. We determine the most popular genre
as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre.
For countries where the maximum number of purchases is shared return all Genres */

/* Method 1: Using CTE */

with popular_genre as (
    select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id, 
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as RowNo 
    from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <= 1


/* Method 2: : Using Recursive */

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


/* 3. Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount */

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1


/* Method 2: Using Recursive */

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







