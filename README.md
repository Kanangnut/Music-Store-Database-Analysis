
# Music Store Database Analysis

Read full article [here](https://kanangnut.github.io/Music-Store-Database-Analysis/).

### Credits
Throughout the development of this project, I drew inspiration from a key video resource: [https://youtu.be/VFIuIjswMKM](https://youtu.be/VFIuIjswMKM).

### Introduction
I conducted a case study on a digital music store using SQL queries, delving into the database creation process and extracting insights from the data. Music reflects our diverse tastes and evolving trends, blending creativity, technology, and audience preferences. Inspired by the insights from [Chinook Music Database](https://www.kaggle.com/datasets/samaxtech/chinook-music-store-data), which showcases global music engagement, I aimed to explore patterns, genres, and artists that shape our collective musical experience.

The project also analyzes datasets, including Employee, Customer, Artist, Playlist, Playlist Track, Album, Track, Invoice, Media, and Genre. The study covers questions from basic to advanced, offering valuable insights into SQL and data analysis.

Overall Goal: Find Insights and find answer of the questions

### Objectives
In this project, I aim to explore the complexities of the music industry by analyzing various facets including sales, customer behavior, genre and artist popularity, playlists, and employee dynamics to answered question:

1. Employee Analysis
2. Sales and Revenue Analysis
3. Customer Behavior Analysis
4. Genre and Artist Popularity
5. Playlists Analysis

### Tools & Installation
- PostgreSQL, pgAdmin4
- SQLite, DB Browser for SQLite
- Power BI

![alt text](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/image/tools.png?raw=true)

To work on this project, you need to install a SQL supported RDBMS. For this project, PostgreSQL is used follow this step:
- Export Database to SQL and CSV file
- Create and Restore Database
- Create tables using the Schema Diagram provided below photo
- Develop SQL query
- Connect Power BI Desktop
- Visualization

#### Schema Diagram

![alt text](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/image/MusicDatabaseSchema.png?raw=true)

## Steps of the Project
1. Database Setup: Understand the structure of the music store database and generate SQL queries to create the necessary tables.<br>
2. Data Analysis: Use SQL queries to analyze the data deeply, identifying patterns, trends, and relationships in the music industry.<br>
3. Visualization: Derive meaningful insights from the analysis to meet the project's goals and objectives.<br>

### Dataset & Database Setup
The dataset used in this project is Chinook.db from Chinook Database (Chinook is a sample database for SQL Server, Oracle, MySQL, PostgreSQL, SQLite, DB2).
Database setup for this project, I used PostgreSQL for SQL queries. First, I exported the database to SQL and CSV files by SQLite, which were then used in PostgreSQL and Power BI for further analysis.

### Data Analysis
I started the analysis by using SQL to query and extract insights directly, avoiding the need for extensive data preprocessing.

### Questions - Answered & Result
Here are some of the questions answered in this project. For more details, please refer to the [SQL](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/doc/music_database_query.sql) file: 

Employee Analysis:
- Who is the senior most employee based on job title?
- Total spending by each Sales Support Agent

Customer Behavior Analysis:
- Which countries have more than 10% of the total customers?
- Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
- Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
- Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
- How many customers are there in each country?
- What is the average spending per customer?
- How does the average spending per customer vary between different countries?

Sales and Revenue Analysis:
- Which country has the highest total sales?
- What is the most popular genre in a specific country? — USA
- How does the sales performance of rock music compare between the USA and Canada?
- Which countries have the most invoices?
- What is the most popular music genre in each country?
- What is the total sales for each genre? This query calculates the total sales for each genre, rounding the result to two decimal places. The results are sorted by total sales in descending order
- Which genres have sales greater than the average?
- Calculate average sales for each genre
- Calculate and display the average sales across all genres
- Show table of total_sales and average_sales in the same table
- What are top10 selling tracks?
- What are the top10 popular countries for music purchases?
- How does the monthly sales data vary?
- Which countries have the most Invoices?

Playlists Analysis:
- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
- Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
- Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

Genre and Artist Popularity:
- We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
- Retrieve the artist's name and the names of all tracks in each album
- Which are the top 5 selling genres based on total sales?
- Which artist has the highest total sales?
- Which genre has the most number of tracks?
- Who are the top3 artists in the “Rock” genre based on total sales?

#### Result

Employee Analysis:
- Mr.Mohan Madan's most senioremployee
- Total spending by each Sales Support Agent <br>

| employee_name | total_spending |
| ------------- | ------------- |
| Jane Peacock | 1731.51 |
| Margaret Park | 1584.00 |
| Steve Johnson | 1393.92 |

Customer Behavior Analysis:
- The countries are more than 10% of the total customers are

| country | customer_count |
| ------------- | ------------- |
| USA | 13 |
| Canada | 8 |

- R Madhav's customer who has spent the most money will be declared the best customer

Sales and Revenue Analysis:
- USA is the highest total sales
- The most popular genre of music in USA is "Rock"

## Insights
Here are the key insights derived from the results:
- USA is the most popular country for music purchases with 1040 purchases followed by Canada and Brazil with 535 and 427 purchases respectively
- Queen is the top-selling artist, with a total of 190 sales
- Rock music is the top selling genre
- The month of January, 2018 had the highest sales

## Dashboard and DAX
Here is [DAX queries in Power BI Desktop](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/doc/DAX.txt) for this project:

![alt text](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/image/DashboardGIF.gif?raw=true)

![alt text](https://github.com/Kanangnut/Music-Store-Database-Analysis/blob/main/assets/image/Untitled%20video%20-%20Made%20with%20Clipchamp.gif?raw=true)

## Conclusion
The project effectively addressed key questions regarding the store's business performance, offering actionable insights into marketing strategies and product offerings. By leveraging advanced data analysis techniques, the project provides valuable recommendations that can drive strategic decisions and enhance business outcomes. The findings not only highlight areas of opportunity but also equip the store with data-driven tools to optimize its operations. This work demonstrates a strong capability in translating complex data into meaningful insights, making it a significant asset for any organization aiming to leverage data for strategic growth.






