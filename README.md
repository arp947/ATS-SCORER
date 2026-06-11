# ATS Resume Scorer

An AI-powered resume analyzer that scores resumes against job descriptions using NLP and ML.

## Features

- Resume parsing (PDF, DOC, DOCX)
- ATS compatibility scoring
- Keyword matching against job descriptions
- Semantic similarity analysis
- Skill validation with project evidence
- AI-powered feedback via Groq LLM
- PDF report generation
- User history with Supabase

## Tech Stack

**Backend**
- FastAPI
- spaCy + SentenceTransformers
- Groq LLM
- Supabase (database + auth)
- WeasyPrint (PDF export)

**Frontend**
- Streamlit

## Project Structure

```
ATS-SCORER/
├── backend/
│   ├── api/          # Routes and auth
│   ├── core/         # Config
│   ├── database/     # Supabase client
│   ├── models/       # Pydantic schemas
│   ├── services/     # Core logic (scoring, parsing, PDF)
│   ├── templates/    # HTML templates for PDF reports
│   ├── utils/        # Helpers
│   └── main.py
├── frontend/
│   ├── components/   # UI components
│   ├── services/     # API + Supabase clients
│   ├── views/        # Page views
│   └── streamlit_app.py
└── Dockerfile
```

## Local Setup

**1. Clone the repo**
```bash
git clone https://github.com/arp947/ATS-SCORER.git
cd ATS-SCORER
```

**2. Install backend dependencies**
```bash
pip install -r backend/requirements.txt
python -m spacy download en_core_web_md
```

**3. Install frontend dependencies**
```bash
pip install -r frontend/requirements.txt
```

**4. Create a `.env` file in the `backend/` folder**
```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_JWT_SECRET=your_jwt_secret
GROQ_API_KEY=your_groq_api_key
```

**5. Create `frontend/.streamlit/secrets.toml`**
```toml
SUPABASE_URL = "your_supabase_url"
SUPABASE_ANON_KEY = "your_supabase_anon_key"
```

**6. Run the backend**
```bash
python -m uvicorn backend.main:app --reload --port 8000
```

**7. Run the frontend**
```bash
cd frontend
python -m streamlit run streamlit_app.py
```

## Deployment

- **Backend** — Hugging Face Spaces (Docker)
- **Frontend** — Streamlit Community Cloud

## License

MIT
