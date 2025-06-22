Akshay Gaikwad hacked your account

use Project_db

alter table artist add primary Key (artist_id)
alter table album add foreign key (artist_id) references artist(artist_id)

alter table artist alter column artist_id int not null


Select playList_id from playlist

-- 1) Give top 5 country which have generated most invoices

Select top 5 count(*) as No_of_Invoices_Generated,billing_country from invoice
group by billing_country
order by No_of_Invoices_Generated desc

--2) Write a query to return a artist id , name and its having longest_song which is in milliseconds

Select  top 1  ar.artist_id,ar.name, max(t.milliseconds)as longest_song
from artist as ar
inner join album as al
on ar.artist_id=al.album_id
inner join track as t
on al.album_id=t.album_id
group by ar.artist_id,ar.name
order by longest_song desc

--3) Write a query get a employee's id,full_name,Hire_date and total number of customers which that employee gives 
--   services 
Select distinct e.employee_id,concat(e.first_name,+' '+e.last_name)as Full_name,cast(e.hire_date as date) as Hire_date,cnt.Total_customers
from employee as e  inner join 
(Select support_rep_id, count(customer_id)as Total_customers from customer as c 
where country like 'A%' or country like 'C%' or country like 'P%'
group by support_rep_id ) as cnt  
on e.employee_id=cnt.support_rep_id

--4) Create a Stored Procedure to give a customer's maximum and minimum amount spend in invoice for 
--purchasing a song

go
Create Procedure SpGetCustspend   
  (@Customer_id int)  
as   
begin   
Select customer_id , max(total)as Max_amt,min(total) as min_amt
from invoice 
where customer_id= @Customer_id
group by customer_id
order by max_amt desc ,min_amt asc
end  

Execute SpGetCustspend 32



   
---6) Find the names of all Customers who have purchased tracks from the album 'Fear Of The Dark' and also
--return its title, invoice details

Select a.title as Title,i.invoice_id as Invoice_id,CAST(i.invoice_date as date)as Invoice_date,
c.customer_id,c.first_name,c.email 
from customer as c 
inner join invoice as i 
on c.customer_id=i.customer_id
inner join invoice_line as il 
on i.invoice_id=il.invoice_id
inner join track as t 
on il.track_id=t.track_id
inner join album as a
on t.album_id=a.album_id
where a.title= 'Fear Of The Dark'

---7) Identify the no of tracks and its media type of each playlist

Select p.playlist_id,count(pt.track_id) as No_of_tracks, m.name as Media_type from playlist as p 
left join  playlist_track  as pt
on p.playlist_id=pt.playlist_id
left join track as t
on pt.track_id=t.track_id
left join media_type as m
on t.media_type_id=m.media_type_id
group by p.playlist_id,m.name
order by p.playlist_id

---8) List all the Employees who reports to an employee named 'Nancy Edwards'

Select concat(first_name ,+ ' ' + Last_name) as Employees_full_name,title,city, email  from employee
where reports_to in 
(Select reports_to from employee where reports_to=2)	
Select * from employee

-- 9) Give the artist's data Which artist have tracks belonging to the genre 'TV Shows'

Select distinct a.artist_id,a.name from artist as a
inner join album  as al
on a.artist_id=al.artist_id
inner join track as t 
on al.album_id=t.album_id
inner join genre as g
on t.genre_id=g.genre_id
where  g.name='TV Shows'

-- 10) Retrieve the Invoice Id and the name of the employee and its name and contact who processed that invoice 

go
Create procedure Getempdetails
@Invoice_id int
as 
begin 
Select i.invoice_id,e.employee_id,e.first_name as Employee_Name,e.phone as Employee_Contact from employee as e 
inner join customer as c 
on e.employee_id=c.support_rep_id
inner join invoice as i 
on c.customer_id=i.customer_id
where i.invoice_id=@Invoice_id
end

execute Getempdetails 610

--11)Identity the Playlist id and its name that has the most expensive track

Select * from playlist 
where playlist_id  in
(Select playlist_id from playlist_track where track_id in 
(Select top 1 track_id from track order by unit_price desc))
 
--12) For Each artist, find the album with the highest unit Price (Show Artist Name and its album and their unit price

Select a.name as Artist_Name,al.title as Album,max(unit_price) as Unit_Price from artist as a 
inner  join  album as al
on a.artist_id=al.artist_id
inner join track as t
on al.album_id=t.album_id
group by a.name, al.title
order by Unit_Price desc

--13) Give an each genre in their media type with how much tracks are there and average tracks 
--       Sort the no of tracks in asceding order

Select g.name as Genre,m.name as Media_Type,count(*) as No_of_Tracks,avg(track_id)as Average_track 
from media_type as m 
inner join track as t 
on m.media_type_id=t.media_type_id
inner join genre as g 
on t.genre_id=g.genre_id
group by g.name,m.name
order by No_of_Tracks desc

--15) Make a Report which shows media type, no of tracks and total sales at every Year

Select m.name as Media_Type,year(i.invoice_date)as Year, count(t.track_id) as No_of_tracks,
       sum(i.total) As Total_Sales
from invoice as i
inner join invoice_line as il
on i.invoice_id=il.invoice_id
inner join track as t
on il.track_id=t.track_id
inner join media_type as m
on t.media_type_id=m.media_type_id
where year(i.invoice_date) = 2018
group by m.name,year(i.invoice_date)
order by m.name,year(i.invoice_date)


Select * from Genre

Select distinct unit_price from invoice_line order by unit_price desc
Select * from employee
---where Year(invoice_date)=2017 and  month(invoice_date)=2
group by year(invoice_date),MONTH(invoice_date)

Select e.employee_id,e.first_name,sum(total) as Total_emp_Sales from employee as e
inner join customer as c
on e.employee_id=c.support_rep_id
inner join invoice as i 
on c.customer_id=i.customer_id
group by e.employee_id,e.first_name




Select Max(distinct total)  from invoice  
Select * from customer
sp_helptext spgetcustspend
--2017
--2018
--2019
--2020

Select year(invoice_date) as Year,month(invoice_date) as Month, Sum(total) as Montly_revenue
from invoice group by month(invoice_date),year(invoice_date)

Select customer_id 
from invoice 
group by customer_id,datepart(year,invoice_date)
having datepart(year,invoice_date) like 2017 
--and 

Select distinct billing_country as Country from invoice
where year(invoice_date) in (2018,2019,2020)

Select billing_country,billing_state,sum(total) from invoice
group by billing_country,billing_state
order by billing_country

Select cast(invoice_date as date)from invoice
where cast(invoice_date as date)=('2017-01-06')

Select total from invoice order by total desc

Select * from invoice where invoice_id=1

Select invoice_id,format(invoice_date,'yyyy-MM')as Invoice_date,total as Invoice_date 
from invoice
group by format(invoice_date,'yyyy-MM')as Invoice_date

Select format(invoice_date,'yyyy-MM')as Invoice_date,count(invoice_id)as No_of_Invoices_generated
,sum(total) as Monthly_Revenue,Avg(total) as Average_Revenue
from invoice
where format(invoice_date,'yyyy-MM')='2018-03'
group by format(invoice_date,'yyyy-MM')



CREATE FUNCTION dbo.GetMonthlyInvoiceSummary
(
    @TargetYearMonth NVARCHAR(7) -- Parameter to specify the year and month (e.g., '2018-03')
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        FORMAT(invoice_date, 'yyyy-MM') AS Invoice_Date,
        COUNT(invoice_id) AS No_of_Invoices_Generated,
        SUM(total) AS Monthly_Revenue,
        AVG(total) AS Average_Revenue
    FROM
        invoice
    WHERE
        FORMAT(invoice_date, 'yyyy-MM') = @TargetYearMonth -- Filter using the passed parameter
    GROUP BY
        FORMAT(invoice_date, 'yyyy-MM')
);
GO

Select dbo.GetMonthlyInvoiceSummary ('2018-03')