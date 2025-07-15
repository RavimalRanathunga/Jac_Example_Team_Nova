import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method='Reason');
def generate_checklist(event_details: str, analysis: str) -> str by llm();
def suggest_budget(event_details: str, checklist: str) -> str by llm();

with entry {
    print("=== Event Planner Assistant ===");
    
    # Collect event details from user
    event_name = input("Enter event name: ");
    number_of_guests = input("Enter number of guests: ");
    event_type = input("Enter event type (wedding, birthday, corporate, etc.): ");
    
    # Combine details for processing
    event_details = f"Event: {event_name}, Guests: {number_of_guests}, Type: {event_type}";
    
    # Agent analyzes event requirements step by step
    print("\nAnalyzing event needs...");
    analysis = analyze_event_needs(event_name, int(number_of_guests), event_type);
    print(f"\nEvent Analysis:\n{analysis}");
    
    # Agent generates a detailed checklist
    print("\nGenerating checklist...");
    checklist = generate_checklist(event_details, analysis);
    print(f"\nEvent Planning Checklist:\n{checklist}");
    
    # Agent suggests a budget based on event details and checklist
    print("\nPreparing budget suggestion...");
    budget = suggest_budget(event_details, checklist);
    print(f"\nBudget Recommendation:\n{budget}");
    
    print("\nThank you for using Event Planner Assistant!");
}


