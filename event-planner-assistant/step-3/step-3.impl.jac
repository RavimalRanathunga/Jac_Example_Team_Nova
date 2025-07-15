impl EventPlanner.init(name: str, guests: int, type: str){
    self.event_name = name;
    self.number_of_guests = guests;
    self.event_type = type;
}

impl EventPlanner.run_planning{
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

