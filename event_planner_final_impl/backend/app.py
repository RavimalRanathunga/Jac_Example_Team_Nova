from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import subprocess
import json
import sys
import os

# Add Jac directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

# Remove the direct import and replace with subprocess functions
# from jac.main import analyze_event_needs, generate_checklist, suggest_budget

# Jac function wrappers using subprocess
def analyze_event_needs(name, guests, event_type):
    result = subprocess.run(
        ["jac", "run", "../jac/main.jac", "--fn", "analyze_event_needs", 
         "--args", name, str(guests), event_type],
        capture_output=True, text=True, check=True
    )
    return result.stdout.strip()

def generate_checklist(event_details, analysis):
    result = subprocess.run(
        ["jac", "run", "../jac/main.jac", "--fn", "generate_checklist",
         "--args", event_details, analysis],
        capture_output=True, text=True, check=True
    )
    return result.stdout.strip()

def suggest_budget(event_details, checklist):
    result = subprocess.run(
        ["jac", "run", "../jac/main.jac", "--fn", "suggest_budget",
         "--args", event_details, checklist],
        capture_output=True, text=True, check=True
    )
    return result.stdout.strip()

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)