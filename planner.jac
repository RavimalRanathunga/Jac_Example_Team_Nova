import from datetime {datetime}
import pandas as pd;

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

}

walker EventWalker
{
    can explore with Event entry
    {
        print(f"Event Name:{event.name} | Date:{event.date} | Guests:{event.guests}");
        print("=====================================");
        print("Checklist Items:");
        checklist_items = [event-->(`?ChecklistItem)];
        description_array = [item.description for item in checklist_items];
        priority_array = [item.priority for item in checklist_items];
        checklist=pd.DataFrame({
            "Description": description_array,
            "Priority": priority_array
        });
        print(checklist);
    }
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
            event = root++>Event(name=name,date=date,guests=guests);

            print("Event created successfully!");
            print("Would you like to create a checklist item for this event? (yes/no)");
            create_checklist:str = input("Please enter your choice: ");

            if create_checklist.lower() == "yes" 
            {
                while True
                {
                    description:str = input("Enter checklist item description: ");
                    priority:int=0;
                    while True
                    {
                        priority = int(input("Enter priority (0-10): "));
                        if priority < 0 or priority > 10
                        {
                            print("Priority must be between 0 and 10. Please try again.");
                        }
                        else
                        {
                            break;
                        }
                    }
                    event+>:create_checklist_item():+>ChecklistItem(description=description, priority=priority);
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

            print("=====================================");
        } 
        elif choice == "2" 
        {
            events = [root-->(`?Event)];
            if len(events)>0
            {
                for event in events
                {
                   event spawn EventWalker(); 
                   print("=====================================");
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
