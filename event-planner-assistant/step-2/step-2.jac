import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: int, type: str) -> str by llm(method="Reason");
def generate_checklist(event_details: str, analysis: str) -> str by llm();
def suggest_budget(event_details: str, checklist: str) -> str by llm();

obj EventPlanner{
    has event_name: str;
    has number_of_guests: int;
    has event_type: str;

    def init(name: str, guests: int, type: str){
        self.event_name = name;
        self.number_of_guests = guests;
        self.event_type = type;
    }

    def run_planning(){

        print("\nAnalyzing event needs...");
        analysis = analyze_event_needs(self.event_name, self.number_of_guests, self.event_type);
        print(f"\nEvent Analysis:\n{analysis}");

        event_details = f"Event: {self.event_name}, Guests: {self.number_of_guests}, Type: {self.event_type}";

        print("\nGenerating checklist...");
        checklist = generate_checklist(event_details, analysis);
        print(f"\nEvent Planning Checklist:\n{checklist}");

        print("\nPreparing budget suggestion...");
        budget = suggest_budget(event_details, checklist);
        print(f"\nBudget Recommendation:\n{budget}");
    }
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