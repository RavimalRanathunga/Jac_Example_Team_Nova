import from mtllm.llms { Gemini }
import uuid;

glob llm = Gemini(model_name="gemini/gemini-2.0-flash", verbose=False);

def analyze_event_needs(name: str, guests: str, type: str) -> str by llm();
def generate_checklist(event_details: str, analysis: str) -> str by llm();
def suggest_budget(event_details: str, checklist: str) -> str by llm();

node Event{
    has id:str=uuid.uuid4();
    has event_name:str="";
    has number_of_guests:str = "";
    has event_type: str = "";
    has budget:str="";
    has checklist:str="";
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
        checklist:str = generate_checklist(self.event_details,event_analysis);
        budget:str = suggest_budget(self.event_details,checklist);

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
            report{"status":"success","events":events};
        }
        else
        {
            report{"status":"No events found"};
        }
    }
}

walker get_a_event
{
    has event_id:str;

    obj __specs__ {
        static has auth: bool = False;
        static has methods: list = ["get"];
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
    has event_details:str="";

    obj __specs__ {
        static has auth: bool = False;
     }

    can get_event with `root entry{
    events = [-->(`?Event)](?id==self.event_id);
    target_event=events[0];

    if self.name
    {
        target_event.event_name=name;
        self.event_details+="Event: " + self.event_name;
    }
    if self.guests
    {
        target_event.number_of_guests=guests;
        self.event_details+=", Guests: " + self.number_of_guests;
    }
    if self.event_type
    {
        target_event.event_type=event_type;
        self.event_details+=", Type: " + self.event_type;
    }

    event_analysis:str = analyze_event_needs(self.name,self.guests,self.event_type);
    checklist:str = generate_checklist(self.event_details,event_analysis);
    budget:str = suggest_budget(self.event_details,checklist);

    target_event.budget=budget;
    target_event.checklist=checklist;

    report {"status":"event updated succesfully"};
    }

}

walker delete_event
{

    obj __specs__ {
        static has auth: bool = False;
     }

    can delete with `root entry{
    events = [-->(`?Event)](?id==self.event_id);
    target_event=events[0];

    if tareget_event{
        del target_event;

        report{"status":"Deleted","id":target_event.id};
    }
    else
    {
        report{"status":"Unsuccessful"};
    }
    }
}

