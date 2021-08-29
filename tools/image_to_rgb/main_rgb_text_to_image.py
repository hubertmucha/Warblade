# importing Image module from PIL package
from PIL import Image
import numpy as np

array = []
height = 64
width = 48

input_data_path = "text_rgb/dummy-data-48x64.data"
output_image_path = "images/dummy-48x64_test.png"

# input_data_path = "text_rgb/agh_test.data"
# output_image_path = "images/agh_test.png"


file_in = open(input_data_path, "rt")
# file_in = open("text_rgb/RGB_OUT.data", "rt")

for line in file_in:
    list_hex = list(line.rstrip())
    for hex_ in list_hex:
        int_value = round(int(hex_, base=16)*(255/15))
        array = np.append(array, int_value)

# Now make pixels into Numpy array of uint8 and reshape to correct height, width and depth
int_array = np.array(array, dtype=np.uint8).reshape((int(height), int(width), 3))

# Now make the Numpy array into a PIL Image and save
Image.fromarray(int_array).save(output_image_path)
