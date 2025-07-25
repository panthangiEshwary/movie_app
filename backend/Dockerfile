# Use lightweight Python image
FROM python:3.9-slim

# Set work directory
WORKDIR /app

# Copy files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port and run app
EXPOSE 5000
CMD ["python", "app.py"]
