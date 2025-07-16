from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import subprocess
import json
import sys
import os
import tempfile
import traceback
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Add Jac directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

# Simplest approach - create standalone scripts for each function
def analyze_event_needs(name, guests, event_type):
    try:
        logger.info(f"Calling analyze_event_needs with: {name}, {guests}, {event_type}")
        
        # Create a simple script that just runs the function
        script_content = f'''
import from mtllm.llms {{ Gemini }};
glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method="Reason");

print(analyze_event_needs("{name}", {guests}, "{event_type}"));
        '''
        
        with tempfile.NamedTemporaryFile(mode='w', suffix='.jac', delete=False) as f:
            f.write(script_content)
            script_file = f.name
        
        logger.info(f"Running script: {script_file}")
        result = subprocess.run(
            ["jac", "run", script_file],
            capture_output=True, text=True, check=False
        )
        
        # Remove temp file
        os.unlink(script_file)
        
        if result.returncode != 0:
            logger.error(f"Error in analyze_event_needs: {result.stderr}")
            return f"Error analyzing event needs: {result.stderr}"
        return result.stdout.strip()
    except Exception as e:
        logger.error(f"Exception in analyze_event_needs: {e}")
        logger.error(traceback.format_exc())
        return f"Error: {str(e)}"

def generate_checklist(event_details, analysis):
    try:
        logger.info(f"Calling generate_checklist")
        
        # Create a simple script that just runs the function
        script_content = f'''
import from mtllm.llms {{ Gemini }};
glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def generate_checklist(event_details: str, analysis: str) -> str by llm();

print(generate_checklist("""
{event_details}
""", """
{analysis}
"""));
        '''
        
        with tempfile.NamedTemporaryFile(mode='w', suffix='.jac', delete=False) as f:
            f.write(script_content)
            script_file = f.name
        
        logger.info(f"Running script: {script_file}")
        result = subprocess.run(
            ["jac", "run", script_file],
            capture_output=True, text=True, check=False
        )
        
        # Remove temp file
        os.unlink(script_file)
        
        if result.returncode != 0:
            logger.error(f"Error in generate_checklist: {result.stderr}")
            return f"Error generating checklist: {result.stderr}"
        return result.stdout.strip()
    except Exception as e:
        logger.error(f"Exception in generate_checklist: {e}")
        logger.error(traceback.format_exc())
        return f"Error: {str(e)}"

def suggest_budget(event_details, checklist):
    try:
        logger.info(f"Calling suggest_budget")
        
        # Create a simple script that just runs the function
        script_content = f'''
import from mtllm.llms {{ Gemini }};
glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def suggest_budget(event_details: str, checklist: str) -> str by llm();

print(suggest_budget("""
{event_details}
""", """
{checklist}
"""));
        '''
        
        with tempfile.NamedTemporaryFile(mode='w', suffix='.jac', delete=False) as f:
            f.write(script_content)
            script_file = f.name
        
        logger.info(f"Running script: {script_file}")
        result = subprocess.run(
            ["jac", "run", script_file],
            capture_output=True, text=True, check=False
        )
        
        # Remove temp file
        os.unlink(script_file)
        
        if result.returncode != 0:
            logger.error(f"Error in suggest_budget: {result.stderr}")
            return f"Error suggesting budget: {result.stderr}"
        return result.stdout.strip()
    except Exception as e:
        logger.error(f"Exception in suggest_budget: {e}")
        logger.error(traceback.format_exc())
        return f"Error: {str(e)}"

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class EventRequest(BaseModel):
    event_name: str
    number_of_guests: int
    event_type: str

class EventResponse(BaseModel):
    event_details: str
    analysis: str
    checklist: str
    budget: str

@app.get("/")
def read_root():
    return {"status": "Event Planner API is running"}

@app.post("/plan-event/", response_model=EventResponse)
async def plan_event(event: EventRequest):
    try:
        # Format event details
        event_details = f"Event: {event.event_name}, Guests: {event.number_of_guests}, Type: {event.event_type}"
        logger.info(f"Processing event: {event_details}")
        
        # Run analysis
        analysis = analyze_event_needs(event.event_name, event.number_of_guests, event.event_type)
        logger.info(f"Analysis complete: {analysis[:50]}...")
        
        # Generate checklist
        checklist = generate_checklist(event_details, analysis)
        logger.info(f"Checklist generated: {checklist[:50]}...")
        
        # Create budget
        budget = suggest_budget(event_details, checklist)
        logger.info(f"Budget created: {budget[:50]}...")
        
        return EventResponse(
            event_details=event_details,
            analysis=analysis,
            checklist=checklist,
            budget=budget
        )
    except Exception as e:
        logger.error(f"Error in plan_event: {e}")
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

# Run with: uvicorn app:app --reload
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)