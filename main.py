from dotenv import load_dotenv
import google.generativeai as genai
from fastapi import FastAPI
from pydantic import BaseModel
import os
from fastapi.middleware.cors import CORSMiddleware

load_dotenv()
genai.configure(api_key=os.environ["API_KEY"])

app = FastAPI()
model = genai.GenerativeModel("gemini-1.5-flash")

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
def read_item(query: Query):
    response = model.generate_content(query.q)
    print(response.text)
    return {"q": response.text}
