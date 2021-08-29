# importing Image module from PIL package
import PIL
from PIL import Image
import numpy as np

# input_image_path = "images/agh_test.png"
# output_data_path = "text_rgb/agh_test.data"

input_image_path = "images/websiteplanet-dummy-48X64.png"
output_data_path = "text_rgb/dummy-data-48x64.data"

# opening a  image
im = Image.open(input_image_path)
im.show()
im = im.transpose(PIL.Image.FLIP_LEFT_RIGHT)
im.show()
im = im.rotate(90, expand=True)
im.show()

# output file
file_out_txt = open(output_data_path, "wt")

width = im.width
height = im.height

print(f"WIDTH = {width}, HEIGHT = {height}\n")
for column in range(width):
    for row in range(height):
        colors = im.getpixel((column, row))
        # getpixel() = (R,G,B,A) - A <- transparency
        #       converting 24-bits (decimal) RGB to 12-bits RGB (in hex)
        r_hex = format(round((colors[0] * 15) / 255), 'X')
        g_hex = format(round((colors[1] * 15) / 255), 'X')
        b_hex = format(round((colors[2] * 15) / 255), 'X')
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
