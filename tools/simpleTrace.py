import time
import os

FILENAME = "en1_x.data"


if os.path.exists(FILENAME):
  os.remove(FILENAME)

f = open(FILENAME,'a')
for i in range(120):
    f.write(str(i) + '\n')

f.close()


