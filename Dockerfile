FROM python:3.11

WORKDIR /app

# Install system deps + Node.js for frontend build
RUN apt-get update && apt-get install -y netcat-openbsd curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy everything
COPY . .

# Build React frontend
RUN cd frontend && npm install && npm run build

RUN sed -i 's/\r$//' wait-for-db.sh && chmod +x wait-for-db.sh

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
