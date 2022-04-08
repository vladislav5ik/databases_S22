--## Part 1
--I used a Python script provided by professor Hamza to generate a table of 1,000,000 customers with random values.
--Then I ran 3 different queries on the table, using the "EXPLAIN ANALYZE" command. The queries and their results are shown below:
--The queries that i will be using for testing perfomance:
EXPLAIN analyze SELECT name FROM customers WHERE age = 21;
EXPLAIN analyze SELECT name FROM customers WHERE name = 'Eric Wade';
EXPLAIN analyze SELECT name FROM customers WHERE address = '0000 Joshua Union\nNorth Jackie, MS 51255';
--The results without indices:
--All queries were executing in 'Seq' scan mode, with average total cost 16700, and execution time > 100 ms.

--Example:
--  Seq Scan on customers  (cost=0.00..16788.74 rows=679 width=118) (actual time=0.043..194.946 rows=12070 loops=1)
--  Filter: (age = 21)
--  Rows Removed by Filter: 987930
--  Planning Time: 0.907 ms
--  Execution Time: 195.362 ms

--Then I created indices on the table for the columns age(b-tree), name(hash), and address(hash) wuth the following queries:
CREATE INDEX age_idx ON customers USING btree(age);
CREATE INDEX name_idx ON customers USING hash(name);
CREATE INDEX address_idx ON customers USING hash(address);

--The results of the original 3 queries were then compared to the results of the same queries with the indices in place.
--Queries were executing either in 'Bitmap' scan mode, with average total cost 10400, and execution time < 0.1 ms for name and address, and ~80 ms for age.

--Example:
--Bitmap Heap Scan on customers  (cost=59.17..10419.71 rows=5000 width=118) (actual time=3.494..81.276 rows=12070 loops=1)
--  Recheck Cond: (age = 21)
--  Heap Blocks: exact=8400
--  ->  Bitmap Index Scan on age_idx  (cost=0.00..57.92 rows=5000 width=0) (actual time=1.956..1.956 rows=12070 loops=1)
--        Index Cond: (age = 21)
--Planning Time: 0.351 ms
--Execution Time: 81.873 ms

--Conclusion:
--As can be seen from the results, the cost of operations and execution time decreased significantly when the indices were in place.

--## Part 2
-- Query 1:
explain analyze select not_rented_film.*
from
    (select f2.*
    from film f2
    except (
    	select f.*
    	from rental as r
    	join inventory as i on r.inventory_id  = i.inventory_id
    	join film f on f.film_id = i.film_id
    	)
    ) as not_rented_film
join film_category fc on fc.film_id = not_rented_film.film_id
join category c on c.category_id = fc.category_id
where (not_rented_film.rating = 'R' or not_rented_film.rating = 'PG-13')
		and (c.name = 'Horror' or c.name = 'Sci-Fi');

--Analyzing output of that query, I've found out that most expensive operation is 'except' in my query, operation costs > 90% of all cost in query.
--Thats expensive because I have decided to subtract from ALL avaliable films thoose ones that was rented (to obain not-rented films).

-- Query 2:
explain analyze select str.store_id, sum(p.amount) as money_metric
from payment p 
join staff as stf on stf.staff_id = p.staff_id 
join store as str on stf.staff_id = str.store_id
where p.payment_date >= (current_timestamp  - interval '30 days')
group by str.store_id;

--I have analyzed query, the most expensive operation was scanning in payment table.
--I think its because payment table have many rows, and there is some date comparisons which may slow query.
--Indices on date coloumn, probably, can speed up query.
--lets add b-tree on payment_date coloumn, where we often use comparison >=
CREATE INDEX payment_date_idx ON payment USING btree(payment_date);
--Yeah! Overall cost was reduced from 365 downto 7. 