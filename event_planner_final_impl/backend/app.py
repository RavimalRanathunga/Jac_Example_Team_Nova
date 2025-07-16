from fastapi import FastAPI, Request
from pydantic import BaseModel


app = FastAPI()

class EventRequest(BaseModel):
    name: str
    guests: int
    type: str

@app.post("/plan-event")
async def plan_event(req: EventRequest):
    jac_code = open("event_planner.jac").read()

    pipeline = JacPipeline(source=jac_code)
    pipeline.run_pipeline()

    # Set inputs to walker
    result = pipeline.run_entry(
        entry_name="PlanEvent",
        args={"event_name": req.name, "number_of_guests": req.guests, "event_type": req.type},
    )

    return {"output": result}
