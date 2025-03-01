FROM python:3.12-slim-bookworm

# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"

# Install required Python packages
RUN pip install fastapi uvicorn requests python-dateutil pandas db-sqlite3 scipy pybase64 python-dotenv httpx markdown duckdb

WORKDIR /app

RUN mkdir -p /data

COPY app.py /app
COPY taskA.py /app
COPY taskB.py /app

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]