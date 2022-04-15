CREATE OR REPLACE FUNCTION public.getcustomerpage(start_id integer, end_id integer)
 RETURNS TABLE(customer_id integer, customer_name varchar(45), address_id smallint)
 LANGUAGE plpgsql
AS $function$
    begin
	    assert start_id > 0, 'start should be > 0';
	   	assert end_id <= 600, 'end should be <= 600';
	   	assert start_id < end_id, 'start should be < that end';
    	return query
    	select c.customer_id, c.first_name, c.address_id
    	from customer c
    	where c.customer_id between start_id and end_id
    	order by c.address_id;
    end
    $function$
;

--Here the eample getcustomerpage(10, 30);
select getcustomerpage(10, 30);
--getcustomerpage |
------------------+
--(10,Dorothy,14) |
--(11,Lisa,15)    |
--(12,Nancy,16)   |
--(13,Karen,17)   |
--(14,Betty,18)   |
--(15,Helen,19)   |
--(16,Sandra,20)  |
--(17,Donna,21)   |
--(18,Carol,22)   |
--(19,Ruth,23)    |
--(20,Sharon,24)  |
--(21,Michelle,25)|
--(22,Laura,26)   |
--(23,Sarah,27)   |
--(24,Kimberly,28)|
--(25,Deborah,29) |
--(26,Jessica,30) |
--(27,Shirley,31) |
--(28,Cynthia,32) |
--(29,Angela,33)  |
--(30,Melissa,34) |
