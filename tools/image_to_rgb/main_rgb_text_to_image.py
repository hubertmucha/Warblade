# importing Image module from PIL package
from PIL import Image
import numpy as np

array = []
height = 64
width = 64
# output file
file_in = open("text_rgb/agh_OUT.data", "rt")
# file_in = open("text_rgb/RGB_OUT.data", "rt")

for line in file_in:
    list_hex = list(line.rstrip())
    for hex_ in list_hex:
        int_value = int(hex_, base=16)
        array = np.append(array, int_value)

# Now make pixels into Numpy array of uint8 and reshape to correct height, width and depth
int_array = np.array(array, dtype=np.uint8).reshape((int(height), int(width), 3))

# Now make the Numpy array into a PIL Image and save
Image.fromarray(int_array).save("images/result_test_2.png")

# width, height = im.size
# print(f"WIDTH = {width}, HEIGHT = {height}\n")
# for row in range(width):
#     for column in range(height):
#         colors = im.getpixel((row, column))
#         # getpixel() = (R,G,B,A) - A <- transparency
# #       converting 24-bits (decimal) RGB to 12-bits RGB (in hex)
#         r_hex = format(round((colors[0]*15)/255), 'X')
#         g_hex = format(round((colors[1]*15)/255), 'X')
#         b_hex = format(round((colors[2]*15)/255), 'X')
#         # writing into output file
#         file_out_txt.write(f"{r_hex}" + f"{g_hex}" f"{b_hex}\n")
