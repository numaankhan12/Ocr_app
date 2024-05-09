# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Update package lists
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara libleptonica-dev libtesseract-dev libleptonica-dev g++ autoconf automake libtool pkg-config libpng-dev libjpeg62-turbo-dev libtiff5-dev zlib1g-dev libwebpdemux2 libwebp-dev libopenjp2-7-dev libgif-dev libarchive-dev libcurl4-openssl-dev
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt
RUN pip3 install uvicorn
RUN pip3 install python-multipart

# Define environment variable
ENV NAME World

# Run the application using uvicorn with automatic reload
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
