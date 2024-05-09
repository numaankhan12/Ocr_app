# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara libleptonica-dev libtesseract-dev libleptonica-dev g++ autoconf automake libtool pkg-config libpng-dev libjpeg62-turbo-dev libtiff5-dev zlib1g-dev libwebpdemux2 libwebp-dev libopenjp2-7-dev libgif-dev libarchive-dev libcurl4-openssl-dev
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart





# Define environment variable
ENV NAME World

# Run the application using uvicorn with automatic reload
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
