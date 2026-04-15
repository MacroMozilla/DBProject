# DBProject

NYU Database Course Project — built with Django and PostgreSQL.

## Tech Stack

- **Backend**: Django 5.2.13
- **Database**: PostgreSQL (via psycopg)
- **Python**: 3.11.9

## Getting Started

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure database

Update `DBProject/settings.py` with your PostgreSQL credentials.

### 3. Run migrations

```bash
python manage.py migrate
```

### 4. Start the server

```bash
python manage.py runserver
```

The app will be available at `http://127.0.0.1:8000/`.
