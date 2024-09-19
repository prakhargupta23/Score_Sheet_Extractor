import TableExtractor as te

import cv2

class Crop:
    def __init__(self):
        path_to_image = "E:/Smart Score/Backend/AppClickedImage.jpg"
        # path_to_image = "D:/Smart Score/API/10_perspective_corrected.jpg"
        table_extractor = te.TableExtractor(path_to_image)
        perspective_corrected_image = table_extractor.execute()