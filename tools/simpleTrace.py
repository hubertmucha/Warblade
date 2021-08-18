import time
import os

FILENAME = "en3_y.txt"

START = 100
OFFSET = 0
HIGHT = 200

if os.path.exists(FILENAME):
  os.remove(FILENAME)

f = open(FILENAME,'a')

for i in range(int(round(150/2))):
    #f.write(str(bin(i+START + OFFSET))[2:] + '\n')
    f.write(str(bin(HIGHT))[2:] + '\n')

for i in range(int(round(150/2))):
    #f.write(str(bin(int(round(150/2) - i+START + OFFSET)))[2:] + '\n')
    f.write(str(bin(HIGHT))[2:] + '\n')
f.close()