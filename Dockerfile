FROM python:3.11

WORKDIR /app

COPY requirements.txt .

# install system + python deps
RUN apt-get update && apt-get install -y netcat-openbsd \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]