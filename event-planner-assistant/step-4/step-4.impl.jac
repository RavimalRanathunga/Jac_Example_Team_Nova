# Graph Construction: Chain nodes and start walking
impl PlanEvent.start_planning {
    input = here ++> InputPhase();
    analysis = input[0] ++> AnalysisPhase();
    checklist = analysis[0] ++> ChecklistPhase();
    checklist[0] ++> BudgetPhase();

    visit [-->];  
}

impl PlanEvent.do_input {
    print("=== Event Planner Assistant ===");

    self.event_name = input("Enter event name: ");
    guests_input = input("Enter number of guests: ");

    if not guests_input.isdigit() {
        print("Invalid number of guests.");
        disengage;
    }

    self.number_of_guests = int(guests_input);
    self.event_type = input("Enter event type (wedding, birthday, corporate, etc.): ");
    
    self.event_details = "Event: " + self.event_name + ", Guests: " + str(self.number_of_guests) + ", Type: " + self.event_type;

    visit [-->];
}


impl PlanEvent.do_analysis {
    print("\nAnalyzing event needs...");
    self.analysis = analyze_event_needs(self.event_name, self.number_of_guests, self.event_type);
    print(f"\nEvent Analysis:\n{self.analysis}");
    visit [-->];
}

impl PlanEvent.do_checklist {
    print("\nGenerating checklist...");
    self.checklist = generate_checklist(self.event_details, self.analysis);
    print(f"\nEvent Planning Checklist:\n{self.checklist}");
    visit [-->];
}

impl PlanEvent.do_budget {
    print("\nPreparing budget suggestion...");
    self.budget = suggest_budget(self.event_details, self.checklist);
    print(f"\nBudget Recommendation:\n{self.budget}");
    print("\nThank you for using Event Planner Assistant!");
    disengage;
}
