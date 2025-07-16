import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method="Reason");
def generate_checklist(event_details: str, analysis: str) -> str by llm();
def suggest_budget(event_details: str, checklist: str) -> str by llm();

obj EventPlanner{
    has event_name: str, number_of_guests: int, event_type: str;
    def init(name: str, guests: int, type: str);
    def run_planning;
}


with entry{
    print("===Event Planner Assistant===");

    name = input("Enter event name: ");
    guests = int(input("Enter number of guests: "));
    ev_type = input("Enter event type (wedding, birthday, corporate, etc.): ");


    planner = EventPlanner(name=name, guests=int(guests),type=ev_type);
    planner.run_planning();

    print("\nThank you for using Event Planner Assistant!");
}