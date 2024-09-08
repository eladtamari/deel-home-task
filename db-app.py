import os
from pymongo import MongoClient
MONGO_URI = os.getenv("MONGO_URI", "mongodb://inbar:tamari@localhost:27017/deel")
client = MongoClient(MONGO_URI)
db = client["deel"]  # Replace 'mydatabase' with your database name
collection = db["ip_addr"] 

print (collection)
data = {
    "key": "ip",
    "value": "10.3.4.3"
}
result = collection.insert_one(data)
x = collection.find_one()
x = collection.find_one()

print(x)


