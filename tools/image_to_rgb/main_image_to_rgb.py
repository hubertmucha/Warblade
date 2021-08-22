# importing Image module from PIL package
from PIL import Image
import numpy as np

# opening a  image
im = Image.open(r"image/websiteplanet-dummy-48X64.png")
# rotate image
im = im.rotate(90)
im.show(())

# output file
file_out_txt = open("text_rgb/RGB_OUT.data", "wt")

width, height = im.size
print(f"WIDTH = {width}, HEIGHT = {height}\n")
for row in range(width):
    for column in range(height):
        colors = im.getpixel((row, column))
        # getpixel() = (R,G,B,A) - A <- transparency
#       converting 24-bits (decimal) RGB to 12-bits RGB (in hex)
        r_hex = format(round((colors[0]*15)/255), 'X')
        g_hex = format(round((colors[1]*15)/255), 'X')
        b_hex = format(round((colors[2]*15)/255), 'X')
        # writing into output file
        file_out_txt.write(f"{r_hex}" + f"{g_hex}" f"{b_hex}\n")


# import cv2
# import numpy as np
# from PIL import Image
#
# file_out_txt = open("text_rgb/RGB_OUT.txt", "wt")
# im_cv = cv2.imread('image/google_logo.png')
#
#
#
# # print(im_cv)
# i = 0
# for line in im_cv:
#     print(f"line nr {i} = {line}")
#     i += 1
#     # file_out_txt.write(line)
#
#
#
#
# # importing Image module from PIL package
# from PIL import Image
# import numpy as np
#
# # opening a  image
# im = Image.open(r"image/google_logo.png")
# image = Image.open(r"image/lion2.png")
#
# im = im.convert('RGB')
#
# print(np.array(im.getchannel(0)))
# print(np.array(im.getchannel(1)))
# print(np.array(im.getchannel(2)))
#
# # use getpallete
# im2 = im.getpalette()
# image2 = image.getpalette()

