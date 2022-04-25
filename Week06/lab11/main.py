import datetime 

from pymongo import MongoClient

client = MongoClient("mongodb://localhost")
db = client['test']

# --------- Task 1
cursor = db.restaurants.find({'cuisine': 'Indian'})
print('all Indian cuisines')
for item in cursor:
    print(item)

cursor = db.restaurants.find({'cuisine': {'$in': ["Indian", "Thai"]}})
print('all Indian and Thai cuisines')
for item in cursor:
    print(item)

cursor = db.restaurants.find(
    {'address.building': '1115', 'address.street': 'Rogers Avenue', 'address.zipcode': '11226'})
print('restaurant with address:  Rogers Avenue, 11226')
for item in cursor:
    print(item)


# --------- Task 2
def insert_restaurant():
    result = db.restaurants.insert_one(
        {
            'address': {
                'building': '1480',
                'coord': [-73.9557413, 40.7720266],
                'street': '2 Avenue', 'zipcode': '10075'
            },
            'borough': 'Manhattan',
            'cuisine': 'Italian',
            'grades': [
                {
                    'date': datetime.datetime(2014, 10, 1, 0, 0),
                    'grade': 'A', 'score': 11
                }
            ],
            'name': 'Vella', 'restaurant_id': '41704620'}
    )
    print('added restaurant "Vella"')


insert_restaurant()


# --------- Task 3

def delete_single_Manhattan_restaurant():
    result = db.restaurants.delete_one(
        {'borough': 'Manhattan'}
    )
    print('deleted a single Manhattan located restaurant')


delete_single_Manhattan_restaurant()


def delete_all_Thai_cuisines_restaurants():
    result = db.restaurants.delete_many(
        {'cuisine': 'Thai'}
    )
    print('deleted all Thai cuisines restaurants')


delete_all_Thai_cuisines_restaurants()


# --------- Task 4
def task4():
    results = db.restaurants.find({'address.street': 'Rogers Avenue'})
    for restaurant in results:
        if restaurant['grades']:
            num_c = 0
            for grade in restaurant['grades']:
                if grade['grade'] == 'C':
                    num_c += 1
            if num_c >= 1:
                db.restaurants.delete_one(restaurant)
            else:
                new_grade = {
                    "date": datetime.datetime.now(),
                    "grade": "C",
                    "score": 0
                }
                query = {"_id": restaurant['_id']}
                new_values = {"$set": {"grades": restaurant['grades'] + [new_grade]}}
                db.restaurants.update_one(query, new_values)
    print('all restaurants were updated or deleted')


task4()
