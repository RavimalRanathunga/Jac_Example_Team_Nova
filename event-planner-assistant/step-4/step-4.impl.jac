# # Implement walker abilities

# impl PlanEvent.start {
#     here ++> input_phase();
#     here ++> analysis_phase();
#     here ++> checklist_phase();
#     here ++> budget_phase();
#     visit [-->];
# }

# impl PlanEvent.gather_input {
#     print("=== Event Planner Assistant ===");
#     self.event_name = input("Enter event name: ");
#     guests_input = input("Enter number of guests: ");
#     if not guests_input.isdigit() {
#         print("Invalid number of guests.");
#         disengage;
#     }
#     self.number_of_guests = int(guests_input);
#     self.event_type = input("Enter event type (wedding, birthday, corporate, etc.): ");
#     self.event_details = f"Event: {self.event_name}, Guests: {self.number_of_guests}, Type: {self.event_type}";
#     visit [-->];
# }

# impl PlanEvent.run_analysis {
#     print("\nAnalyzing event needs...");
#     self.analysis = analyze_event_needs(self.event_name, self.number_of_guests, self.event_type);
#     print(f"\nEvent Analysis:\n{self.analysis}");
#     visit [-->];
# }

# impl PlanEvent.make_checklist {
#     print("\nGenerating checklist...");
#     self.checklist = generate_checklist(self.event_details, self.analysis);
#     print(f"\nEvent Planning Checklist:\n{self.checklist}");
#     visit [-->];
# }

# impl PlanEvent.estimate_budget {
#     print("\nPreparing budget suggestion...");
#     self.budget = suggest_budget(self.event_details, self.checklist);
#     print(f"\nBudget Recommendation:\n{self.budget}");
#     print("\nThank you for using Event Planner Assistant!");
#     disengage;
# }
