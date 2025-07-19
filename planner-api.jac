import uuid;
import from mtllm {Model}

glob llm = Model(model_name = "gemini/gemini-2.0-flash");

def analyze_event_needs(name: str, guests: str, type: str) -> str by llm();
def generate_checklist_as_List(event_details: str, analysis: str) -> list[str] by llm();
def suggest_budget_as_float(event_details: str, checklist: list[str]) -> float by llm();

node Event{
    has id:str=str(uuid.uuid4());
    has event_name:str="";
    has number_of_guests:str = "";
    has event_type: str = "";
    has budget:float=0.00;
    has checklist:list[str]=[];
}

walker create_event
{
    has name:str;
    has guests:str;
    has event_type:str;
    has event_details:str="";

     obj __specs__ {
        static has auth: bool = False;
     }
    

    can create with `root entry
    {

        self.event_details= "Event: " + self.name + ", Guests: " + self.guests + ", Type: " + self.event_type;
        event_analysis:str = analyze_event_needs(self.name,self.guests,self.event_type);
        checklist:list[str] = generate_checklist_as_List(self.event_details,event_analysis);
        budget:float = suggest_budget_as_float(self.event_details,checklist);

        event = root ++> Event(event_name=self.name,number_of_guests=self.guests,event_type=self.event_type,budget=budget,checklist=checklist);

    }
}

walker get_events
{
    obj __specs__ {
        static has auth: bool = False;
        static has methods: list = ["get"];
     }

    can get_events with `root entry{

        events = [-->(`?Event)];
        if(len(events)>0)
        {
            report {"data":events};
        }
        else
        {
            report{"status":"No events found"};
        }
    }
}

walker get_event
{
    has event_id:str;

    obj __specs__ {
        static has auth: bool = False;
        static has methods:list =["post"];
     }

    can get_event with `root entry
    {
        events = [-->(`?Event)](?id==self.event_id);

        if(len(events)>0)
        {
        report {"event":events[0]};
        }
        else
        {
            report {"status":"Event not found"};
        }
    }
}

walker update_event
{
    has event_id:str;
    has name:str="";
    has guests:str="";
    has event_type:str="";
    has budget:float=0.00;
    has checklist:list=[];

    obj __specs__ {
        static has auth: bool = False;
        static has methods:list=["patch"];
     }

    can update_event with `root entry{
    events = [-->(`?Event)](?id==self.event_id);
    target_event=events[0];

    if self.name
    {
        target_event.event_name=self.name;
    }
    if self.guests
    {
        target_event.number_of_guests=self.guests;
    }
    if self.event_type
    {
        target_event.event_type=self.event_type;
    }

    
    target_event.budget=self.budget;
    target_event.checklist=self.checklist;

    report {"status":"event updated succesfully"};
    }

}

walker delete_event
{

    has event_id:str;

    obj __specs__ {
        static has auth: bool = False;
        static has methods:list =["delete"];
     }

    can delete with `root entry{
    events = [-->(`?Event)](?id==self.event_id);

    if events{
        target_event=events[0];
        del target_event;

        report{"status":"Deleted","id":self.event_id};
    }
    else
    {
        report{"status":"Unsuccessful"};
    }
    }
}
