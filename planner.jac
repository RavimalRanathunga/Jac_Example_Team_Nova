import from datetime {datetime}

node Event 
{
    has name: str;
    has date: str;
    has guests: int;
}

node ChecklistItem 
{
    has description: str;
    has priority: int = 0;
}

edge create_checklist_item
{
    has scheduled_at:str;
}

with entry{

    loop:bool=True;

    while loop
    {

        print("Welcome to the Event Planner Assistant!");
        print("1. Create Event");
        print("2. View Events");
        print("3. Exit");

        choice:str = input("Please select an option: ");

        if choice == "1" 
        {
            name:str = input("Enter event name: ");
            date:str = input("Enter event date (YYYY-MM-DD): ");
            guests:int = int(input("Enter number of guests: "));
            print("");
            event=root ++>Event(name=name,date=date,guests=guests);

            print("Event created successfully!");
            print("Would you like to create a checklist item for this event? (yes/no)");
            create_checklist:str = input("Please enter your choice: ");

            if create_checklist.lower() == "yes" 
            {
                while True
                {
                    description:str = input("Enter checklist item description: ");
                    priority:int = int(input("Enter priority (0-10): "));
                    event+>:create_checklist_item(scheduled_at=datetime.now().strftime("%H:%M:%S")):+>ChecklistItem(description=description, priority=priority);
                    print("Checklist item created successfully!");
                    print("");
                    c:str = input("Enter any key to exit or 'c' to continue: ");
                    if c.lower() == "c"
                    {
                        continue;
                    }
                    else
                    {
                        break;
                    }
                }
            }
            else 
            {
                print("No checklist item created for this event.");
                print("");
            }
        } 
        elif choice == "2" 
        {
            events = [root-->(`?Event)];
            if len(events)>0
            {
                for event in events
                {
                    print(f"Event Name:{event.name} | Date:{event.date} | Guests:{event.guests}");
                    print("Checklist Items:");
                    checklist_items = [event-->(`?ChecklistItem)];
                    print(checklist_items);
                }
            }
            else
            {
                print("No Events Created");
                print("=====================================");
            }
        } 
        elif choice == "3" 
        {
            break;
        } 
        else 
        {
            print("Invalid option, please try again.");
        }
    }
}
