FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the backend requirements first to leverage Docker caching
COPY backend/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 1. Download the spacy model during the build stage
RUN python -m spacy download en_core_web_md

# 2. Pre-download your SentenceTransformer model during the build stage so it works offline!
# (Replace 'all-MiniLM-L6-v2' with the exact model name you are using in your main.py file)
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"

# Copy the rest of the backend application code
COPY backend/ .

# Expose the port Hugging Face requires
EXPOSE 7860

# Run FastAPI using Uvicorn
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
