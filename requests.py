import requests

r = requests.get('https://bloomington.doublemap.com/map/v2/buses')
data = r.json()

# Function to retrieve API data
def parse():
    data = r.json()
    return data

# Data Structure for individual bus locations
class Bus():
    def __init__(self, lat, lon, angle):
        self.lat = lat
        self.lon = lon
        self.angle = angle

### Create new Convert function
def convert(num):
    return num

Buses = []

for bus in data:
    Bus(bus["lat"], bus["lon"], bus["heading"])
