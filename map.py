import threading
import pygame
pygame.init()
background = pygame.image.load("bloomington-map.png")
screen = pygame.display.set_mode((770, 697))
pygame.display.set_caption('Double Map')
screen.blit(background, (0, 0))
clock = pygame.time.Clock()

class Rect:
    x = 0
    y = 0

square = pygame.Surface((20, 20))

while not False:
    screen.blit(square, (Rect.x, Rect.y))
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            posn = pygame.mouse.get_pos()
            pygame.draw.rect(screen, (255, 0, 0), (posn[0], posn[1], 10, 10))
    Rect.x += 1 
    Rect.y += 1
    pygame.display.update()
    screen.blit(background, (0, 0))
    clock.tick(60)

