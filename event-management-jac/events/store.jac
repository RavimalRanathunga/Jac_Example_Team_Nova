"""Event planning backend - AI-assisted checklist/budget generation, per-user
persistence. Every endpoint here is authenticated (plain `def`): each caller's
`root` is their own isolated graph, so events never cross between users."""

import from datetime { datetime }

def _now -> str {
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S");
}

def analyze_event_needs(name: str, guests: str, event_type: str) -> str by llm();
sem analyze_event_needs = "Analyze what an event with this name, guest count, and type will need.";
sem analyze_event_needs.name = "The event's name.";
sem analyze_event_needs.guests = "The expected number of guests.";
sem analyze_event_needs.event_type = "The kind of event, e.g. Wedding, Birthday Party.";

def generate_checklist(event_details: str, analysis: str) -> list[str] by llm();
sem generate_checklist = "Generate a practical, ordered planning checklist for this event.";
sem generate_checklist.event_details = "A short description of the event.";
sem generate_checklist.analysis = "The prior analysis of the event's needs.";

def suggest_budget(event_details: str, checklist: list[str]) -> float by llm();
sem suggest_budget = "Suggest a total budget in USD for this event given its checklist.";
sem suggest_budget.event_details = "A short description of the event.";
sem suggest_budget.checklist = "The event's planning checklist.";

node Event {
    has event_name: str = "",
        number_of_guests: str = "",
        event_type: str = "",
        budget: float = 0.0,
        checklist: list[str] = [],
        created_at: str = "",
        updated_at: str = "";
}

def:priv create_event(name: str, guests: str, event_type: str) -> Event {
    event_details = f"Event: {name}, Guests: {guests}, Type: {event_type}";
    analysis: str = analyze_event_needs(name, guests, event_type);
    checklist: list[str] = generate_checklist(event_details, analysis);
    budget: float = suggest_budget(event_details, checklist);
    now = _now();
    return root ++> Event(
        event_name=name,
        number_of_guests=guests,
        event_type=event_type,
        budget=budget,
        checklist=checklist,
        created_at=now,
        updated_at=now
    );
}

def:priv list_events() -> list[Event] {
    events = [root -->][?:Event];
    events.sort(key=lambda (e: Event) { e.created_at; }, reverse=True);
    return events;
}

def:priv get_event(event_id: str) -> Event | None {
    for e in [root -->][?:Event] {
        if jid(e) == event_id {
            return e;
        }
    }
    return None;
}

def:priv update_event(
    event_id: str,
    name: str = "",
    guests: str = "",
    event_type: str = "",
    checklist: list[str] | None = None,
    budget: float | None = None
) -> Event | None {
    target: Event | None = None;
    for e in [root -->][?:Event] {
        if jid(e) == event_id {
            target = e;
        }
    }
    if target is None {
        return None;
    }
    if name {
        target.event_name = name;
    }
    if guests {
        target.number_of_guests = guests;
    }
    if event_type {
        target.event_type = event_type;
    }
    if checklist is not None {
        target.checklist = checklist;
    }
    if budget is not None {
        target.budget = budget;
    }
    target.updated_at = _now();
    return target;
}

def:priv delete_event(event_id: str) -> dict[str, str] {
    for e in [root -->][?:Event] {
        if jid(e) == event_id {
            del e;
            return {"status": "deleted", "id": event_id};
        }
    }
    return {"status": "not_found", "id": event_id};
}
