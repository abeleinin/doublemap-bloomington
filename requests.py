import requests
from PIL import Image

r = requests.get('https://bloomington.doublemap.com/map/v2/buses')

data = r.json()



x = 0
"""
for bus in data:
    print("bus", x)
    print(bus["lat"])
    print(bus["lon"])
    x += 1
"""

