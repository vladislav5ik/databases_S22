import psycopg2
from geopy.geocoders import Nominatim
import time


def get_config():
    return {
        "dbname": "lab08_2",  # dvdrental table from lab08
        "user": "postgres",
        "password": "postgres",
        "host": "localhost",
        "port": "5432"
    }


if __name__ == '__main__':
    geolocator = Nominatim(user_agent="myapplicationname123")
    config = get_config()
    conn = psycopg2.connect(**config)

    cur = conn.cursor()
    cur.execute('''create or replace function getAddresses()
    returns table (id int, address varchar(50))
    language plpgsql
    as $$
    begin
    	return query select a.address_id, a.address
    	from address a
    	where a.city_id between 400 and 600
    		and a.address like '%11%';
    end
    $$''') 
    cur.execute('ALTER TABLE address ADD COLUMN IF NOT EXISTS longitude float;')
    cur.execute('ALTER TABLE address ADD COLUMN IF NOT EXISTS latitude float;')
    conn.commit()

    # Fetching all addresses with specific constrain by using function
    cur.callproc('getAddresses', ())
    result = cur.fetchall()
    for id, address in result:
        longitude = 0
        latitude = 0
        try:
            # Getting the coordinates by address
            location = geolocator.geocode(address)
            longitude = location.longitude
            latitude = location.latitude
        except:
            pass
        #print(longitude, latitude)
        # Updating row
        cur.execute(f"""UPDATE address
SET latitude = {latitude},
 longitude = {longitude}
WHERE address_id = {id};""")
        time.sleep(1)  # timeout for accessing geographic api
        conn.commit()

    cur.close()
    conn.close()