"""Event Planner Assistant - interactive CLI.

Menu-driven tool to create events with manual checklists, or hand event
planning to an LLM for an automatic checklist + budget suggestion."""

def analyze_event_needs(name: str, guests: int, event_type: str) -> str by llm();
sem analyze_event_needs = "Analyze what an event with this name, guest count, and type will need.";
sem analyze_event_needs.name = "The event's name.";
sem analyze_event_needs.guests = "The expected number of guests.";
sem analyze_event_needs.event_type = "The kind of event, e.g. wedding, birthday, corporate.";

def generate_checklist(event_details: str, analysis: str) -> list[str] by llm();
sem generate_checklist = "Generate a practical, ordered planning checklist for this event.";
sem generate_checklist.event_details = "A short description of the event.";
sem generate_checklist.analysis = "The prior analysis of the event's needs.";

def suggest_budget(event_details: str, checklist: list[str]) -> float by llm();
sem suggest_budget = "Suggest a total budget in USD for this event given its checklist.";
sem suggest_budget.event_details = "A short description of the event.";
sem suggest_budget.checklist = "The event's planning checklist.";

node Event {
    has name: str = "",
        date: str = "",
        guests: int = 0,
        event_type: str = "",
        budget: float = 0.0;
}

node ChecklistItem {
    has description: str = "",
        priority: int = 0;
}

edge HasItem: Event --> ChecklistItem {}

def print_event(event: Event) -> None {
    print(f"Event Name: {event.name} | Date: {event.date} | Guests: {event.guests} | Type: {event.event_type}");
    if event.budget > 0 {
        print(f"Suggested Budget: ${event.budget}");
    }
    print("Checklist Items:");
    items = [event ->:HasItem:->];
    if len(items) == 0 {
        print("  (none)");
    } else {
        for item in items {
            print(f"  - {item.description} (priority {item.priority})");
        }
    }
    print("=====================================");
}

def add_checklist_items(event: Event) -> None {
    while True {
        description = input("Enter checklist item description: ");
        priority = 0;
        while True {
            priority_input = input("Enter priority (0-10): ");
            if not priority_input.isdigit() {
                print("Priority must be a number between 0 and 10. Please try again.");
                continue;
            }
            priority = int(priority_input);
            if priority < 0 or priority > 10 {
                print("Priority must be between 0 and 10. Please try again.");
            } else {
                break;
            }
        }
        event +>:HasItem():+> ChecklistItem(description=description, priority=priority);
        print("Checklist item created successfully!\n");
        again = input("Enter any key to exit or 'c' to continue: ");
        if again.lower() != "c" {
            break;
        }
    }
}

def create_event_manual -> None {
    name = input("Enter event name: ");
    date = input("Enter event date (YYYY-MM-DD): ");
    guests_input = input("Enter number of guests: ");
    if not guests_input.isdigit() {
        print("Invalid number of guests.");
        return;
    }
    event_type = input("Enter event type (wedding, birthday, corporate, etc.): ");

    event = root ++> Event(name=name, date=date, guests=int(guests_input), event_type=event_type);
    print("Event created successfully!");

    create_checklist = input("Would you like to create a checklist item for this event? (yes/no): ");
    if create_checklist.lower() == "yes" {
        add_checklist_items(event);
    } else {
        print("No checklist item created for this event.");
    }
    print("=====================================");
}

def create_event_with_ai -> None {
    print("=== AI Event Planner Assistant ===");
    name = input("Enter event name: ");
    guests_input = input("Enter number of guests: ");
    if not guests_input.isdigit() {
        print("Invalid number of guests.");
        return;
    }
    guests = int(guests_input);
    event_type = input("Enter event type (wedding, birthday, corporate, etc.): ");
    date = input("Enter event date (YYYY-MM-DD): ");

    event_details = f"Event: {name}, Guests: {guests}, Type: {event_type}";

    print("\nAnalyzing event needs...");
    analysis = analyze_event_needs(name, guests, event_type);
    print(f"\nEvent Analysis:\n{analysis}");

    print("\nGenerating checklist...");
    checklist = generate_checklist(event_details, analysis);
    print("\nEvent Planning Checklist:");
    for item in checklist {
        print(f"  - {item}");
    }

    print("\nPreparing budget suggestion...");
    budget = suggest_budget(event_details, checklist);
    print(f"\nBudget Recommendation: ${budget}");

    event = root ++> Event(
        name=name, date=date, guests=guests, event_type=event_type, budget=budget
    );
    for description in checklist {
        event +>:HasItem():+> ChecklistItem(description=description);
    }
    print("\nEvent saved. Thank you for using Event Planner Assistant!");
    print("=====================================");
}

def view_events -> None {
    events = [root -->][?:Event];
    if len(events) == 0 {
        print("No Events Created");
        print("=====================================");
        return;
    }
    for event in events {
        print_event(event);
    }
}

with entry:__main__ {
    running = True;
    while running {
        print("Welcome to the Event Planner Assistant!");
        print("1. Create Event");
        print("2. Create Event with AI Assistant");
        print("3. View Events");
        print("4. Exit");

        choice = input("Please select an option: ");

        if choice == "1" {
            create_event_manual();
        } elif choice == "2" {
            create_event_with_ai();
        } elif choice == "3" {
            view_events();
        } elif choice == "4" {
            running = False;
        } else {
            print("Invalid option, please try again.");
        }
    }
}
