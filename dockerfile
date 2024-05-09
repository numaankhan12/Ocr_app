FROM ubuntu:latest
 
RUN apt-get --fix-missing update && apt-get --fix-broken install && apt-get install -y poppler-utils && apt-get install -y tesseract-ocr && \
apt-get install -y libtesseract-dev && apt-get install -y libleptonica-dev && ldconfig && apt-get install -y python3.9 && \
apt-get install -y python3-pip && apt install -y ffmpeg libsm6 libxext6
 
# Get language data
RUN apt-get install tesseract-ocr-eng tesseract-ocr-ara
 
WORKDIR /app
COPY . /app
 
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
 
EXPOSE 80
 
# Set the locale to C.UTF-8 for Python 3
ENV LANG C.UTF-8

# Run the application using uvicorn with automatic reload
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "${PORT}"]
