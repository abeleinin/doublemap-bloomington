import requests
from threading import Timer

# Function to retrieve data from DoubleMap API
def parse():
    r = requests.get('https://iub.doublemap.com/map/v2/buses')
    data = r.json()
    return data

# Bus Longitude and Latitude 
class Bus():
    def __init__(self, lon, lat, angle):
        self.lon = lon
        self.lat = lat
        self.angle = angle

# Define the coordinates of Bloomington
class view():
    def __init__(self, xmin, xmax, ymin, ymax):
        self.xmin = xmin
        self.xmax = xmax
        self.ymin = ymin
        self.ymax = ymax

bloom = view(-86.52846, -86.49543, 39.163165, 39.186316)

# Convert one type of unit to another
def convert(a1, b1, a2, b2, a):
    x = ((a2 - a) * b1)
    y = ((a - a1) * b2)
    z = (a2 - a1)
    return ((x + y) / z)

width = 770
height = 697

# Return the bus coordinateds converted into numbers that fit screen aspect ratio 
def cartToScreen(view, bus):
    bus_lon = convert(view.xmin, 0, view.xmax, width, bus.lon)
    bus_lat = convert(view.ymin, height, view.ymax, 0, bus.lat)
    return Bus(bus_lon, bus_lat, bus.angle)

buses = []

cancel = False

# Function to get all bus locations every 5 seconds from the API
def updater():
    buses.clear()
    if cancel:
        return
    else:
        for bus in parse():
            init_bus = Bus(bus["lon"], bus["lat"], bus["heading"])
            final_bus = cartToScreen(bloom, init_bus)
            buses.append(final_bus)

        t = Timer(5.0, updater)
        t.start()
        return buses

