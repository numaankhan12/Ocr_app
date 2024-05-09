FROM ubuntu:18.04
 
# Set the working directory to /app
WORKDIR /app
 
# Copy the current directory contents into the container at /app
COPY . /app
 
# Install any needed packages specified in requirements.txt
RUN apt-get --fix-missing update && apt-get --fix-broken install && apt-get install -y poppler-utils && apt-get install -y tesseract-ocr && \
apt-get install -y libtesseract-dev && apt-get install -y libleptonica-dev && ldconfig && apt-get install -y python3.8 && \
apt-get install -y python3-pip && apt install -y libsm6 libxext6
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart
 
# Make port 80 available to the world outside this container
EXPOSE 80
 
# Define environment variable
ENV NAME World

# Run the application using uvicorn with automatic reload
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
