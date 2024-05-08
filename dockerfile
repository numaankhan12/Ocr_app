# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart
USER root
RUN chmod 777 /Tesseract-OCR/tesseract.exe




# Define environment variable
ENV NAME World

# Run the application using uvicorn with automatic reload
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
