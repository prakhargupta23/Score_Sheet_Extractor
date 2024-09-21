import cv2
import numpy as np
import glob
from PIL import Image

def order_points(pts):
    '''Rearrange coordinates to order: top-left, top-right, bottom-right, bottom-left'''
    rect = np.zeros((4, 2), dtype='float32')
    pts = np.array(pts)
    s = pts.sum(axis=1)
    rect[0] = pts[np.argmin(s)]  # Top-left
    rect[2] = pts[np.argmax(s)]  # Bottom-right
    diff = np.diff(pts, axis=1)
    rect[1] = pts[np.argmin(diff)]  # Top-right
    rect[3] = pts[np.argmax(diff)]  # Bottom-left
    return rect.astype('int').tolist()

def scan(img):
    dim_limit = 1080
    max_dim = max(img.shape)
    if max_dim > dim_limit:
        resize_scale = dim_limit / max_dim
        img = cv2.resize(img, None, fx=resize_scale, fy=resize_scale)

    orig_img = img.copy()
    kernel = np.ones((5, 5), np.uint8)
    img = cv2.morphologyEx(img, cv2.MORPH_CLOSE, kernel, iterations=5)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (11, 11), 0)
    canny = cv2.Canny(gray, 0, 200)
    canny = cv2.dilate(canny, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (21, 21)))

    contours, _ = cv2.findContours(canny, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    page = sorted(contours, key=cv2.contourArea, reverse=True)[:5]

    if len(page) == 0:
        return orig_img

    for c in page:
        epsilon = 0.02 * cv2.arcLength(c, True)
        corners = cv2.approxPolyDP(c, epsilon, True)
        if len(corners) == 4:
            break

    corners = sorted(np.concatenate(corners).tolist())
    corners = order_points(corners)

    w1 = np.sqrt((corners[0][0] - corners[1][0]) ** 2 + (corners[0][1] - corners[1][1]) ** 2)
    w2 = np.sqrt((corners[2][0] - corners[3][0]) ** 2 + (corners[2][1] - corners[3][1]) ** 2)
    w = max(int(w1), int(w2))

    h1 = np.sqrt((corners[0][0] - corners[2][0]) ** 2 + (corners[0][1] - corners[2][1]) ** 2)
    h2 = np.sqrt((corners[1][0] - corners[3][0]) ** 2 + (corners[1][1] - corners[3][1]) ** 2)
    h = max(int(h1), int(h2))

    destination_corners = order_points(np.array([[0, 0], [w - 1, 0], [0, h - 1], [w - 1, h - 1]]))

    homography, _ = cv2.findHomography(np.float32(corners), np.float32(destination_corners), method=cv2.RANSAC,
                                          ransacReprojThreshold=3.0)

    un_warped = cv2.warpPerspective(orig_img, np.float32(homography), (orig_img.shape[1], orig_img.shape[0]))

    final = un_warped[:destination_corners[2][1], :destination_corners[2][0]]

    # Save final cropped image as ans.jpg
    cv2.imwrite('ans.jpg', final)

    return final

# Main processing loop
for img_path in glob.glob('Backend\0_original.jpg'):
    try:
        img = cv2.imread(img_path)
        print(f"Processing: {img_path}")

        scanned_img = scan(img)

        print("Scanned image saved as ans.jpg.")

    except Exception as e:
        print(f'Failed to process image: {e}')

# Resize the saved image
image_path = 'ans.jpg'
image = cv2.imread(image_path)

if image is None:
    print("Error loading image")
else:
    # Resize the image to 550x800 pixels
    new_dimensions = (550, 800)
    resized_image = cv2.resize(image, new_dimensions)

    # Save the resized image as ans2.jpg
    cv2.imwrite('ans2.jpg', resized_image)

# Function to crop the image
def crop_and_show_image(input_image_path, output_image_path):
    with Image.open(input_image_path) as img:
        width, height = img.size
        
        # Calculate cropping coordinates
        left = 0  # 0% of width
        upper = height * 0.53  # 53% of height
        right = width * 0.6  # 60% of width
        lower = height * 0.6  # 60% of height
        
        # Crop the image
        cropped_img = img.crop((left, upper, right, lower))
        
        # Save the cropped image
        cropped_img.save(output_image_path)
        print(f"Cropped image saved at {output_image_path}")
        
        # Show the cropped image
        cropped_img.show()

# Example usage for cropping
input_image = 'ans2.jpg'
output_image = 'Backend\roll_image.jpg'
crop_and_show_image(input_image, output_image)

cv2.destroyAllWindows()
