import uuid;
import from mtllm {Model}
import from datetime {datetime}
import from fastapi {status,HTTPException}

glob llm = Model(model_name = "gemini/gemini-2.0-flash");

def analyze_event_needs(name: str, guests: str, type: str) -> str by llm();
def generate_checklist(event_details: str, analysis: str) -> list[str] by llm();
def suggest_budget(event_details: str, checklist: list[str]) -> float by llm();

node Event{
    has id:str=str(uuid.uuid4());
    has event_name:str="";
    has number_of_guests:str = "";
    has event_type: str = "";
    has budget:float=0.00;
    has checklist:list[str]=[];
    has created_by:str="";
    has created_at:str=datetime.now().strftime("%Y-%m-%d %H:%M:%S");
    has updated_at:str=datetime.now().strftime("%Y-%m-%d %H:%M:%S");
}

node Profile
{
    has id:str=str(uuid.uuid4());
    has username:str="";
    has email:str="";
    has password:str="";
}

edge sign_in
{
    has sign_in:bool=False;
}

walker create_event
{
    has name:str;
    has guests:str;
    has event_type:str;
    has created_by:str;
    has event_details:str="";

     obj __specs__ {
        static has auth: bool = False;
    }
    

    can create with `root entry
    {

        self.event_details= "Event: " + self.name + ", Guests: " + self.guests + ", Type: " + self.event_type;
        event_analysis:str = analyze_event_needs(self.name,self.guests,self.event_type);
        checklist:list[str] = generate_checklist(self.event_details,event_analysis);
        budget:float = suggest_budget(self.event_details,checklist);

        users = [-->(`?Profile)](?id==self.created_by);

        event = users[0] ++> Event(event_name=self.name,number_of_guests=self.guests,event_type=self.event_type,budget=budget,checklist=checklist,created_by=self.created_by);

        report{"data":event[0]};

    }
}

walker get_events
{
    has created_by:str;

    obj __specs__ {
        static has auth: bool = False;
     }

    can get_events with `root entry{

        profiles = [-->(`?Profile)](?id==self.created_by);
        events = [profiles[0]-->(`?Event)];

        if(len(events)>0)
        {
            report {"data":events};
        }
        else
        {
            report {data:[]};
        }
    }
}

walker get_event
{
    has event_id:str;

    obj __specs__ {
        static has auth: bool = False;
     }

    can get_event with `root entry
    {
        events = [-->-->(`?Event)](?id==self.event_id);

        if(len(events)>0)
        {
        report {"data":events[0]};
        }
        else
        {
            # report {"status":"Event not found"};
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"post with id: {self.event_id} not found");
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
    events = [-->-->(`?Event)](?id==self.event_id);
    if(len(events)==0)
    {
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"post with id: {self.event_id} not found");
    }
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
    target_event.updated_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S");
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
    events = [-->-->(`?Event)](?id==self.event_id);
    if(len(events)==0)
    {
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"post with id: {self.event_id} not found");
    }

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

walker register
{
    has username:str;
    has email:str;
    has password:str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can register with `root entry
    {
        user = [-->(`?Profile)](?email==self.email);

        if(len(user)>0)
        {
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=f"{self.email} already registered");
        }
        else
        {
            users=root++>Profile(username=self.username,password=self.password,email=self.email);
            report {"data":users[0]};
        }
    }

}

walker login
{
    has email:str;
    has password:str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can login with `root entry
    {
        users = [-->(`?Profile)](?email==self.email);

        if(users)
        {
            if(users[0].password == self.password)
            {
                report{"data":users[0]};
            }
            else
            {
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"Wrong credentials");
            }
        }
        else
        {
           raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"No account found");
        }
    }
}

walker logout
{

}
