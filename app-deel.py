from flask import Flask, request, jsonify
import requests
import os
from pymongo import MongoClient

app = Flask(__name__)

# Function to get the public IP of the given IP address
def get_public_ip(ip):
    try:
        response = requests.get(f"http://ipinfo.io/{ip}/json")
        data = response.json()
        return data.get("ip")
    except Exception as e:
        return str(e)

@app.route('/', methods=['GET', 'POST'])
def reverse_public_ip():
    # Parse the incoming request JSON for the IP address
    ip_data = request.get_json()
    
    if not ip_data or 'ip' not in ip_data:
        return jsonify({"error": "IP address is required"}), 400

    ip = ip_data['ip']
    # Get the public IP of the provided IP address
    public_ip = get_public_ip(ip)
    rev_ip = ".".join(reversed(public_ip.split('.'))) 
   
    write_to_db(rev_ip)
    
    if public_ip:
        # Return the public IP in the response
        return jsonify({"public_ip": public_ip}), 200
    else:
        return jsonify({"error": "Could not retrieve public IP"}), 500
    
def write_to_db(ip_rev):
    user = os.getenv('db_user','default_value')
    password = os.getenv('db_pass', 'default')
    #print(user)
    #print(password)
    
    MONGO_URI = os.getenv("MONGO_URI", f"mongodb://{user}:{password}@localhost:27017/deel")
    try:
        client = MongoClient(MONGO_URI)
        db = client["deel"]  # Replace 'mydatabase' with your database name
        collection = db["ip_addr"] 
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

    
    data = {"ip": f"{ip_rev}" }
    
    try:
        result = collection.insert_one(data)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5003)
