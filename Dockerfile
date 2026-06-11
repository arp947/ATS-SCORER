FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Install OS libraries required by python-magic and PDF rendering.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagic1 \
        file \
        shared-mime-info \
        libcairo2 \
        libpango-1.0-0 \
        libpangoft2-1.0-0 \
        libgdk-pixbuf-2.0-0 \
        libffi8 \
    && rm -rf /var/lib/apt/lists/*

# Copy the backend requirements file first
COPY backend/requirements.txt ./backend/

# Install dependencies
RUN pip install --no-cache-dir -r backend/requirements.txt

# 1. Download the primary spacy model during the build stage
RUN python -m spacy download en_core_web_md

# Copy the entire backend directory into the container's backend folder
COPY backend/ ./backend/

# 2. Pre-download the SentenceTransformer model using the exact import paths
RUN python -c "from backend.core.config import SENTENCE_TRANSFORMER_MODEL; from sentence_transformers import SentenceTransformer; SentenceTransformer(SENTENCE_TRANSFORMER_MODEL)"

# Expose the port Hugging Face requires
EXPOSE 7860

# Run FastAPI pointing to the backend module
CMD ["python", "-m", "uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "7860"]
