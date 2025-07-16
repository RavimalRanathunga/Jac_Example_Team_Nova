import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method="Reason");
def generate_checklist(event_details: str, analysis: str) -> str by llm();
def suggest_budget(event_details: str, checklist: str) -> str by llm();

# Step Nodes
node Root { }
node InputPhase { }
node AnalysisPhase { }
node ChecklistPhase { }
node BudgetPhase { }

# Walker that visits each phase
walker PlanEvent {
    has event_name: str = "";
    has number_of_guests: int = 0;
    has event_type: str = "";
    has event_details: str = "";
    has analysis: str = "";
    has checklist: str = "";
    has budget: str = "";

    can start_planning with `root entry;
    can do_input with InputPhase entry;
    can do_analysis with AnalysisPhase entry;
    can do_checklist with ChecklistPhase entry;
    can do_budget with BudgetPhase entry;
}

# Entry Point
with entry {
                  
    PlanEvent() spawn root;      
}

