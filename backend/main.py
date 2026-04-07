from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Dict
from google import genai
from google.genai import types

app = FastAPI(title="Derma AI Chatbot Advanced")

from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = "AIzaSyCv09Ie4Rn9EXIwb-O9EkeYgJcr0M1AYBM"
client = genai.Client(api_key=API_KEY)
MODEL_NAME = "gemini-2.5-flash"

class Message(BaseModel):
    user_id: str
    text: str

chat_history: Dict[str, List[str]] = {}

@app.post("/chat")
def chat(msg: Message):
    if msg.user_id not in chat_history:
        chat_history[msg.user_id] = []
    chat_history[msg.user_id].append(f"User: {msg.text}")
    prompt = "\n".join(chat_history[msg.user_id]) + "\nAssistant:"
    prompt += """
Rules:
- You are a dermatology assistant.
- Respond in the SAME language as the user (Arabic or English).
- Give advice for skin conditions.
- Suggest lifestyle tips (clothes, food, hygiene).
- Include a medical reference.
- Always add: "This is not a medical diagnosis".
"""
    response = client.models.generate_content(
        model=MODEL_NAME,
        contents=[prompt],
        config=types.GenerateContentConfig(temperature=0.7)
    )
    reply = response.text.strip()
    reply = reply.replace("**", "").replace("*", "")
    paragraphs = [p.strip() for p in reply.split("\n") if p.strip()]
    chat_history[msg.user_id].append(f"Assistant: {reply}")
    return {"paragraphs": paragraphs}