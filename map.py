import pygame
import threading
import get_data
pygame.init()
background = pygame.image.load("bloomington-map.png")
screen = pygame.display.set_mode((770, 697))
pygame.display.set_caption('Bloomington DoubleMap in Python')
screen.blit(background, (0, 0))
clock = pygame.time.Clock()

while not False:
    # Check if user has tried exiting the application
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            get_data.cancel = True
            exit()
    # Update bus location from get_data updater function 
    for bus in get_data.updater():
        pygame.draw.rect(screen, (255, 0, 0), (bus.lon, bus.lat, 8, 8))

    pygame.display.update()
    screen.blit(background, (0, 0))
    clock.tick(0.3)

