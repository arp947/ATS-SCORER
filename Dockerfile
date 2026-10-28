FROM python:3.12-slim

WORKDIR /app

# OS libraries for python-magic and WeasyPrint
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagic1 \
        libmagic-dev \
        file \
        shared-mime-info \
        libcairo2 \
        libpango-1.0-0 \
        libpangoft2-1.0-0 \
        libpangocairo-1.0-0 \
        libgdk-pixbuf-2.0-0 \
        libffi8 \
        libharfbuzz0b \
        libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Install CPU-only torch FIRST to prevent the GPU version (~2.5GB) from being pulled in
RUN pip install --no-cache-dir torch==2.3.1 --index-url https://download.pytorch.org/whl/cpu

COPY backend/requirements.txt ./backend/

# Install remaining deps
RUN pip install --no-cache-dir -r backend/requirements.txt

# Download smaller spaCy model
RUN python -m spacy download en_core_web_sm

COPY backend/ ./backend/

EXPOSE 7860

# Model downloads at first startup (cached in HF persistent storage)
CMD ["python", "-m", "uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "7860"]
