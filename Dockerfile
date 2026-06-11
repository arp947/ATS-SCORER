FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the backend requirements first to leverage Docker caching
COPY backend/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 1. Download the primary spacy model during the build stage
RUN python -m spacy download en_core_web_md

# 2. Automatically pre-download whatever SENTENCE_TRANSFORMER_MODEL is set to in your config
RUN python -c "from backend.core.config import SENTENCE_TRANSFORMER_MODEL; from sentence_transformers import SentenceTransformer; SentenceTransformer(SENTENCE_TRANSFORMER_MODEL)"

# Copy the rest of the backend application code
COPY backend/ .

# Expose the port Hugging Face requires
EXPOSE 7860

# Run FastAPI using Uvicorn
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
