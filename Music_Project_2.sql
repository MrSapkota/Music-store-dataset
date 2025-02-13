Q1. Who is the senior most employee based on job title?

select top 1 * 
from employee
order by levels desc;

Q2. Which Countries have the most invoices?

Select count(*) as c,billing_country 
from invoice
group by billing_country
order by c desc;

Q3. What are top 3 values of total invoice?

Select total from invoice
order by total desc

Q4. Which city had the best customers? We would like to throw a promotional Music festival in the city we made
the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the
city name & sum of all invoice totals

Select top 1 sum(total)as Invoice_Total, billing_city
from invoice  
group by billing_city
Order by Invoice_Total DESC

Select * from invoice
Select * from customer

Q5. Who is the best customer? the customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money. 

Select top 1 invoice.customer_id,customer.first_name as FS, customer.last_name as LS,sum(invoice.total) as Total 
from invoice
FULL Join customer on invoice.customer_id = customer.customer_id
group by invoice.customer_id, customer.first_name, customer.last_name
Order by Total desc

Q6:Write query to return the email,first name, last name, & genre of all rock music listeners. Return your 
List ordered alphabetically by email starting with A. 

Select * from genre
Select * from customer
Select * from track
Select * from invoice_line

SELECT DISTINCT
    customer.email AS email,
	customer.first_name,
    customer.last_name,
    genre.name AS genre_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id 
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

Q7. Lets invite the artists who have written the most rock music in our dataset. write a query that return 
the artist name and total track count of the top 10 rock bands. 

select * from artist
select * from album

Select top 10
		artist.artist_id,
		artist.name as N, 
		count(artist.artist_id) as number_of_songs
From track
Join album on album.album_id = track.album_id
Join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
Group by artist.artist_id, artist.name
order by number_of_songs desc


Q8. Return all the track names that have a song length longer than the average song length. Return the name and
mili second for each track. Order by the song length with the longest song listed first. 

Select * from track


Select name,milliseconds
from track
where milliseconds >(
		Select AVG(milliseconds) as avg_length
		from track)
order by milliseconds desc


Q9. Find how much amount spent by each customer on artists?Write a query to return customer name
artist name and total spent.

With best_selling_artist As(
	select artist.artist_id as artist_id, artist.name as artist_name,
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1 
	Order by 3 desc
	limit 1
)
Select c.customer_id, c.first_name, C.last_namem bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spend
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc


WITH best_selling_artist AS (
    SELECT TOP 1
        artist.artist_id AS artist_id, 
        artist.name AS artist_name,
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY artist.artist_id, artist.name
    ORDER BY total_sales DESC
)
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name, 
    SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;

Q10. We want to find out the most popular music genre for each country. we determine the most popular
genre as the genre with the higest amount of purchase. write a query that returns each country along
with the top genre. For countries where the maximum number of purchases us shared return all genres.

with popular_genre As
(
	select count(invoice_line.quantity) as purchases, customer.customer, genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as RowNo
	From invoice_line
	Join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <=1


WITH popular_genre AS (
    SELECT 
        COUNT(il.quantity) AS purchases, 
        c.customer_id, 
        g.name AS genre_name, 
        g.genre_id,
        ROW_NUMBER() OVER (
            PARTITION BY c.country 
            ORDER BY COUNT(il.quantity) DESC
        ) AS RowNo
    FROM invoice_line il
    JOIN invoice i ON i.invoice_id = il.invoice_id
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY c.customer_id, g.name, g.genre_id, c.country
)
SELECT * 
FROM popular_genre 
WHERE RowNo <= 1;


Q11. Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent. For coutries
where the top amount spent is shared, provide all customer who spent this amount. 

with recursive
	customer_with_country As(
		Select customer.customer_id,first_name, last_name, billing_country, sum(total) as total_spending
		From invoice
		join customer on customer.customer.customer_id = invoice.customer_id
		Group by 1, 2, 3, 4
		Order by 1,5 Desc),

	country_max_spending as (
		select billing_country, max(total_spending) as max_spending
		from customer_with_country
		group by billing_country)

Select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name
From customer_with_country cc
Join country_max_spending ms
on cc.billing_country = ms.billing_country
where cc.total_spending = ms.max_spending
order by 1

WITH customer_with_country AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spending
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, i.billing_country
),
country_max_spending AS (
    SELECT 
        billing_country,
        MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country
)
SELECT 
    cc.billing_country,
    cc.total_spending,
    cc.first_name,
    cc.last_name
FROM customer_with_country cc
JOIN country_max_spending ms
    ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY cc.billing_country;