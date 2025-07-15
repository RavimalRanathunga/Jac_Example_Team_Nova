import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);

# ========== NODE DEFINITIONS ==========

node Event {
    has name: str;
    has date: str;
    has guests: int;
}

node ChecklistItem {
    has description: str;
    has priority: int = 0;
}

# ========== AGENT DEFINITIONS ==========

agent EventAgent {
    can create_event(name: str, date: str, guests: int) {
        spawn here --> Event(name=name, date=date, guests=guests);
        report "📅 Event created: " + name + " on " + date + " for " + str(guests) + " guests.";
        ChecklistAgent.generate_checklist(name=name, guests=guests);
    }
}

agent ChecklistAgent {
    can generate_checklist(name: str, guests: int) {
        str checklist_text = llm("Generate a checklist for organizing an event called " + name +
                  " for " + str(guests) + " people. Return 10 lines as plain lines.");

        report "📝 Checklist from MTLLM:\n" + checklist_text;

        for line in checklist_text.split("\n") {
            if line.strip() != "" {
                spawn here --> ChecklistItem(description=line.strip());
            }
        }

        PriorityAgent.assign_priorities();
    }
}

agent PriorityAgent {
    can assign_priorities() {
        for item in here.out(ChecklistItem) {
            str desc = item.description;
            str p = llm("Assign a priority (1=low, 10=high) for this task: " + desc);
            item.priority = int(p.strip());
            report "⭐ Priority " + p.strip() + " set for: " + desc;
        }
    }
}

# ========== WALKER TO START THE FLOW ==========

walker start_planner {
    can start with entry;

    can entry() {
        EventAgent.create_event(name="birthday party", date="2025-09-29", guests=10);
    }
}

# ========== CLI ENTRY POINT ==========

with entry:__main__ {
    root spawn start_planner;
}
