import pytesseract
from PIL import Image
import re
import json
from pdf2image import convert_from_path
from datetime import datetime, timedelta

# Set the path to the Tesseract executable
pytesseract.pytesseract.tesseract_cmd = "/usr/bin/tesseract.exe"
# pytesseract.pytesseract.tesseract_cmd = r'c:\Program Files\Tesseract-OCR\tesseract.exe'

def process_image(image_path):
    try:
        # Process the image
        extracted_text = extract_text_from_image(image_path)

        if extracted_text:
            # Extract information from the extracted text
            data = {
                
                "extracted_data": {
                    "Name": extract_name_dob_sex(extracted_text)["Name"],
                    "DateOfBirth": extract_name_dob_sex(extracted_text)["DateOfBirth"],
                    "Sex": extract_name_dob_sex(extracted_text)["Sex"],
                    "IDNumber": extract_id_number(extracted_text),
                    "ExpiryDate": extract_expiry_date(extracted_text),
                    "IssuingDate": extract_issuing_date(extract_expiry_date(extracted_text)),
                    "Occupation": extract_occupation(extracted_text),
                    "Employer": extract_employer(extracted_text),
                    "IssuingPlace": extract_issuing_place(extracted_text)
                }
            }
            return data
        else:
            return {"error": "Text extraction failed."}

    except Exception as e:
        return {"error": str(e)}

def extract_text_from_image(image_path):
    try:
        # Pre-processing for clearer images (resize, convert to grayscale, and enhance contrast)
        image = Image.open(image_path)
        image = image.resize((image.width * 2, image.height * 2))
        image = image.convert("L")
        
        # Use pytesseract to extract text
        extracted_text = pytesseract.image_to_string(image, lang='eng+ara', config='--psm 6')
        
        return extracted_text.strip()
    
    except Exception as e:
        raise e

def extract_name_dob_sex(text):
    name_pattern = r'Name:\s*(.*)'
    dob_pattern = r'Date of Birth:\s*(\d{2}/\d{2}/\d{4})'  # Regular expression pattern for date of birth
    sex_pattern = r'Sex:\s*([MF])'  # Regular expression pattern for sex (M or F)
    
    # Extract name
    name_match = re.search(name_pattern, text)
    name = name_match.group(1).strip() if name_match else None
    
    # Extract date of birth
    dob_match = re.search(dob_pattern, text)
    dob = dob_match.group(1).strip() if dob_match else None
    
    # Extract sex
    sex_match = re.search(sex_pattern, text)
    sex = sex_match.group(1).strip() if sex_match else None
    
    return {"Name": name, "DateOfBirth": dob, "Sex": sex}

def extract_id_number(text):
    id_number_pattern = r'784-\d{4}-\d{7}-\d'  # Regular expression pattern to match ID number starting with "784" and containing hyphens
    id_match = re.search(id_number_pattern, text)
    if id_match:
        return id_match.group()
    else:
        return None

def extract_expiry_date(text):
    expiry_date_pattern = r'[MF](\d{2})(\d{2})(\d{2})'  # Regular expression pattern for expiry date in format MMDDYY
    expiry_date_match = re.search(expiry_date_pattern, text)
    if expiry_date_match:
        day = expiry_date_match.group(1)
        month = expiry_date_match.group(2)
        year = expiry_date_match.group(3)
        return f"{year}-{month}-{day}"  # Adjust the year format
    else:
        return None

def extract_issuing_date(expiry_date):
    if expiry_date:
        expiry_datetime = datetime.strptime(expiry_date, '%y-%m-%d')
        issuing_datetime = expiry_datetime - timedelta(days=365) + timedelta(days=1)  # Subtract 1 year and add 1 day
        return issuing_datetime.strftime('%y-%m-%d')
    else:
        return None

def extract_occupation(text):
    occupation_pattern = r'Occupation:\s*(.*)'
    occupation_match = re.search(occupation_pattern, text, re.IGNORECASE)  # Case insensitive match
    return occupation_match.group(1).strip() if occupation_match else None

def extract_employer(text):
    employer_pattern = r'Employer:\s*(.*)'
    employer_match = re.search(employer_pattern, text, re.IGNORECASE)  # Case insensitive match
    return employer_match.group(1).strip() if employer_match else None

def extract_issuing_place(text):
    issuing_place_pattern = r'Issuing\s+Place:\s*(.*)'
    issuing_place_match = re.search(issuing_place_pattern, text)
    return issuing_place_match.group(1).strip() if issuing_place_match else None



        







