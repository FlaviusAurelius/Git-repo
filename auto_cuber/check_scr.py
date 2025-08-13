import pyautogui
import keyboard
import pytesseract
from PIL import ImageOps, ImageEnhance
import cv2
import numpy as np

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'


def select_region_two_clicks():
    """Wait for 'q' key press to capture two mouse positions defining a rectangle region."""
    print("Press 'q' to select bottom-left point.")
    keyboard.wait('q')
    first_click = pyautogui.position()
    print(f"Bottom-left point selected: {first_click}")
    print("Press 'q' to select top-right point.")
    keyboard.wait('q')
    second_click = pyautogui.position()
    print(f"Top-right point selected: {second_click}")
    x1, y1 = min(first_click[0], second_click[0]), min(first_click[1], second_click[1])
    x2, y2 = max(first_click[0], second_click[0]), max(first_click[1], second_click[1])
    print(f"Selected region: ({x1}, {y1}, {x2}, {y2})")
    return (x1, y1, x2, y2)

def capture_screenshot(region, filename="test.png"):
    """Capture a screenshot of the specified region and save it as an image file."""
    x1, y1, x2, y2 = region
    width = x2 - x1
    height = y2 - y1
    if width <= 0 or height <= 0:
        print("Invalid region: width or height is zero or negative.")
        return None
    screenshot = pyautogui.screenshot(region=(x1, y1, width, height))
    screenshot.save(filename)
    print(f"Screenshot saved as {filename}")
    return screenshot

def extract_text(image):
    try:
        # Convert PIL image to OpenCV format
        image_np = np.array(image)
        image_cv = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)

        # Step 1: Save raw image
        cv2.imwrite("step1_raw.png", image_cv)
        print("Saved raw image as step1_raw.png")

        # Step 2: Invert the image
        inverted = cv2.bitwise_not(image_cv)
        cv2.imwrite("step2_inverted.png", inverted)
        print("Saved inverted image as step2_inverted.png")

        # Step 3: Convert to grayscale
        gray = cv2.cvtColor(inverted, cv2.COLOR_BGR2GRAY)
        cv2.imwrite("step3_gray.png", gray)
        print("Saved grayscale image as step3_gray.png")

        # Step 4: Enhance contrast
        contrast_img = cv2.convertScaleAbs(gray, alpha=1.5, beta=-127)  # alpha controls contrast, beta brightness
        cv2.imwrite("step4_contrast.png", contrast_img)
        print("Saved contrast-enhanced image as step4_contrast.png")

        # Step 5: OCR with traditional Chinese and English
        text = pytesseract.image_to_string(contrast_img, lang="chi_tra+eng", config="--psm 6")
        if not text.strip():
            print("No text detected in the screenshot.")
            return None
        print(f"Extracted text:\n{text}")
        return text
    except Exception as e:
        print(f"Error extracting text: {e}")
        return None
    
# def extract_text(image):
#     """Extract text from a screenshot using Pytesseract with preprocessing for Traditional Chinese."""
#     try:
#         # Preprocessing: Convert to grayscale, invert (light text on dark), and enhance contrast
#         image = image.convert("L")  # Grayscale
#         image = ImageEnhance.Contrast(image).enhance(2.0)  # Increase contrast
#         image = ImageOps.invert(image)  # Invert for light text on dark background
#         # Extract text with Traditional Chinese and English support, PSM 6 for single uniform block
#         text = pytesseract.image_to_string(image, lang="chi_tra+eng", config="--psm 6")
#         if not text.strip():
#             print("No text detected in the screenshot.")
#             return None
#         print(f"Extracted text:\n{text}")
#         return text
#     except Exception as e:
#         print(f"Error extracting text: {e}")
#         return None

if __name__ == "__main__":
    region = select_region_two_clicks()
    if region:
        screenshot = capture_screenshot(region)
        if screenshot:
            extract_text(screenshot)
