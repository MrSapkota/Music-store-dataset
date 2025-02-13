# Music-store-dataset
Data analysis using MS SQL 

# Music Store Dataset

This dataset contains information related to a music store, including customers, invoices, tracks, albums, artists, and genres. It is designed to simulate a real-world music store database and can be used for analysis, reporting, and SQL practice.

## Dataset Overview

The dataset consists of the following tables:

1. **Customer**:
   - Contains information about the store's customers.
   - Columns: `customer_id`, `first_name`, `last_name`, `email`, `country`, etc.

2. **Invoice**:
   - Contains details about customer purchases.
   - Columns: `invoice_id`, `customer_id`, `invoice_date`, `billing_country`, `total`, etc.

3. **InvoiceLine**:
   - Contains line items for each invoice.
   - Columns: `invoice_line_id`, `invoice_id`, `track_id`, `unit_price`, `quantity`, etc.

4. **Track**:
   - Contains information about individual music tracks.
   - Columns: `track_id`, `name`, `album_id`, `genre_id`, `unit_price`, etc.

5. **Album**:
   - Contains information about music albums.
   - Columns: `album_id`, `title`, `artist_id`, etc.

6. **Artist**:
   - Contains information about music artists.
   - Columns: `artist_id`, `name`, etc.

7. **Genre**:
   - Contains information about music genres.
   - Columns: `genre_id`, `name`, etc.

## Queries

                                          
Q1. Who is the senior most employee based on job title?
Answer: Here the employee table
 ![image](https://github.com/user-attachments/assets/8582da8f-5525-40de-b778-e39ae9611256)


select * from employee
order by levels desc

![image](https://github.com/user-attachments/assets/de370862-e630-48e2-a110-5b3bda9d01e9)


select top 1 * 
from employee
order by levels desc;
 

![image](https://github.com/user-attachments/assets/75aae142-f61c-4e94-9781-675a2adaee13)








Q2. Which Countries have the most invoices?
Select * from invoice;
![image](https://github.com/user-attachments/assets/13f1e9d6-6b01-462b-993c-9e9d24c6d568)


Select count(*) as c,billing_country 
from invoice
group by billing_country
order by c desc;

 ![image](https://github.com/user-attachments/assets/47b82b8b-d713-4ee4-82c2-e23a47992fd8)


Q3. What are top 3 values of total invoice?
Select total from invoice
order by total desc
 

![image](https://github.com/user-attachments/assets/5ad0e632-acb5-4e9b-8ee1-e22f303ccca6)










Select top 3 total from invoice
order by total desc
 


![image](https://github.com/user-attachments/assets/575284d8-4879-4869-9c99-2af38c0fa437)










Q4. Which city had the best customers? We would like to throw a promotional Music festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
Select sum(total)as Invoice_Total, billing_city
from invoice  
group by billing_city
Order by Invoice_Total DESC
 
![image](https://github.com/user-attachments/assets/6d3115ca-2532-463a-8759-5bf87530be02)









Select top 1 sum(total)as Invoice_Total, billing_cityfrom invoice  
group by billing_city
Order by Invoice_Total DESC
 


![image](https://github.com/user-attachments/assets/4f581092-48d0-4612-b8c3-22bc23e0091c)










Q5. Who is the best customer? the customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money. 
Select invoice.customer_id,customer.first_name as FS, customer.last_name as LS,sum(invoice.total) as Total 
from invoice
FULL Join customer on invoice.customer_id = customer.customer_id
group by invoice.customer_id, customer.first_name, customer.last_name
Order by Total desc
 
![image](https://github.com/user-attachments/assets/ba753915-521e-4f5f-a812-6417b4d2e915)











Select top 1 invoice.customer_id,customer.first_name as FS, customer.last_name as LS,sum(invoice.total) as Total 
from invoice
FULL Join customer on invoice.customer_id = customer.customer_id
group by invoice.customer_id, customer.first_name, customer.last_name
Order by Total desc
 


![image](https://github.com/user-attachments/assets/ab49e48d-b51c-4589-837c-e72018627b86)














Q6:Write query to return the email,first name, last name, & genre of all rock music listeners. Return your  List ordered alphabetically by email starting with A.
SELECT DISTINCT
    customer.email AS email,
    customer.last_name,
    genre.name AS genre_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id 
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;
![image](https://github.com/user-attachments/assets/348b9d91-6938-46e7-a565-fd7228051301)

 




Q7. Lets invite the artists who have written the most rock music in our dataset. write a query that return the artist name and total track count of the top 10 rock bands.

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
 
![image](https://github.com/user-attachments/assets/5e3a9946-1633-459f-854e-806d6b8e65f6)




Q8. Return all the track names that have a song length longer than the average song length. Return the name and millisecond for each track. Order by the song length with the longest song listed first.
Select name,milliseconds
from track
where milliseconds >(
		Select AVG(milliseconds) as avg_length
		from track)
order by milliseconds desc
 

![image](https://github.com/user-attachments/assets/d3d76c1d-d4e7-4716-80c9-c408fc565293)









Q9. Find how much amount spent by each customer on artists?Write a query to return customer name artist name and total spent.
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
 
![image](https://github.com/user-attachments/assets/4f7c253a-ce5b-426c-920a-d45f36c1bfed)

	
















Q10. We want to find out the most popular music genre for each country. we determine the most popular genre as the genre with the highest amount of purchase. write a query that returns each country along with the top genre. For countries where the maximum number of purchases us shared return all genres.

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


![image](https://github.com/user-attachments/assets/0d595a2f-1227-4ae4-bece-09646dfd07df)


 



Q11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customer who spent this amount. 
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
 

![image](https://github.com/user-attachments/assets/f47e2461-1d31-4f14-b198-6800d3bea895)



