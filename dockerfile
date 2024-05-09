FROM mcr.microsoft.com/windows/servercore:ltsc2019
RUN chmod -R 777 /app/Tesseract-OCR

# Install additional dependencies
RUN powershell -Command \
    choco install -y poppler-utils ; \
    choco install -y python --version 3.9 ; \
    choco install -y ffmpeg

# Set the working directory
WORKDIR /app

# Copy the application code
COPY . /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Expose port 80
EXPOSE 80

# Set the locale to C.UTF-8 for Python 3
ENV LANG C.UTF-8

# Run the application using uvicorn with automatic reload
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
