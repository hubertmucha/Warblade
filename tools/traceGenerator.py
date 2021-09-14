import time
import os

X_START = 30
Y_START = 500
SHIFT = 20

FILENAME = "en1.data"

WAIT = 0

# i = X_START
# xTable = []
# while i < X_START + SHIFT:
#     xTable.append(i)
#     i = i + 1

# while i > X_START :
#     xTable.append(i)
#     i = i - 1


# for x in xTable:
#     print("{}*".format(' '*(x-X_START)))
#     time.sleep(WAIT)
#     os.system('cls')

# yTable = [Y_START]*len(xTable)
# sTable = [0]*len(xTable)

# FOR TESTING 
# for i in range(SHIFT*2):
#     print("x = {},y = {}, s = {}".format(xTable[i], yTable[i], sTable[i]))

# if os.path.exists(FILENAME):
#   os.remove(FILENAME)

# f = open(FILENAME,'a')
# for i in range(SHIFT*2):
#     f.write(str(xTable[i]) + '\n')
#     f.write(str(yTable[i]) + '\n')
#     f.write(str(sTable[i]) + '\n')
# f.close()


for x in range(50):
    print(str(bin(200))[2:])

for x in range(200,400,4):
    print(str(bin(x))[2:])

for x in range(50):
    print(str(bin(400))[2:])