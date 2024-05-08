import requests
import json

# Local path of the image
image_path = 'Images/nmk_final.jpeg'

# Upload the local image
url = 'http://ocrapp-production-3458.up.railway.app/upload'
files = {'file': open(image_path, 'rb')}
resp = requests.post(url=url, files=files)

# Print the response content for debugging
print(resp.content)

# Try to parse the response as JSON
try:
    json_response = resp.json()
    print(json_response)
except json.decoder.JSONDecodeError:
    print("Response is not in JSON format")
