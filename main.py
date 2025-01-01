from dotenv import load_dotenv
import google.generativeai as genai
from fastapi import FastAPI
from pydantic import BaseModel
import os
from fastapi.middleware.cors import CORSMiddleware

load_dotenv()
genai.configure(api_key=os.environ["API_KEY"])

app = FastAPI()
model = genai.GenerativeModel("gemini-pro")

# Configure for more natural, conversational responses
generation_config = {
    "temperature": 0.8,  # Slightly higher for more natural language
    "top_p": 0.9,
    "top_k": 40,
    "max_output_tokens": 1024,  # Shorter for more focused summaries
}

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class Query(BaseModel):
    q: str


@app.post("/generate")
async def generate_content(query: Query):
    try:
        response = model.generate_content(
            query.q,
            generation_config=generation_config,
        )

        if not response.text:
            return {"q": "No response generated. Please try again."}

        return {"q": response.text}

    except Exception as e:
        print(f"Error generating content: {str(e)}")
        return {"q": f"Error generating content: {str(e)}"}
