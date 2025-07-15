# import from mtllm.llms { Gemini }

# glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

# # ========== NODE DEFINITIONS ==========

node Event {
    has name: str;
    has date: str;
    has guests: int;
}

# node ChecklistItem {
#     has description: str;
#     has priority: int = 0;
# }



# # ========== WALKER TO START THE FLOW ==========




# ========== CLI ENTRY POINT ==========

with entry{

    loop:bool=True;

    while loop{
        print("Welcome to the Event Planner Assistant!");
        print("1. Create Event");
        print("2. View Events");
        print("3. Exit");

        choice:str = input("Please select an option: ");

        if choice == "1" {
            name:str = input("Enter event name: ");
            date:str = input("Enter event date (YYYY-MM-DD): ");
            guests:int = int(input("Enter number of guests: "));
            event = root ++>Event(name=name,date=date,guests=guests)
        } elif choice == "2" {
            events = [root-->()]
        } elif choice == "3" {
            break;
        } else {
            print("Invalid option, please try again.");
        }
    }
}
