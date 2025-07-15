# import from mtllm.llms { Gemini }

# glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

# def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method="Reason");
# def generate_checklist(event_details: str, analysis: str) -> str by llm();
# def suggest_budget(event_details: str, checklist: str) -> str by llm();

# # Define node bodies
# node input_phase { }
# node analysis_phase { }
# node checklist_phase { }
# node budget_phase { }

# # Define walker
# walker PlanEvent {
#     has event_name: str;
#     has number_of_guests: int;
#     has event_type: str;
#     has event_details: str;
#     has analysis: str;
#     has checklist: str;
#     has budget: str;

#     can start with `root entry;
#     can gather_input with input_phase;
#     can run_analysis with analysis_phase;
#     can make_checklist with checklist_phase;
#     can estimate_budget with budget_phase;
# }

# # Entry point
# with entry {
#     PlanEvent() spawn `root;
# }