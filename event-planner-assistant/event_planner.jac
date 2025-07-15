import from mtllm.llms {Gemini }

# glob llm = OpenAI(model_name="gpt-4o",verbose=False);
 glob llm =
    Gemini(model_name="gemini-1.5-flash", verbose=False);

# ========== NODE DEFINITIONS ==========

node Event {
    has str name;
    has str date;
    has int guests;
}

node ChecklistItem {
    has str description;
    has int priority = 0;
}

# ========== AGENT DEFINITIONS ==========

agent EventAgent {
    can create_event(str name, str date, int guests) {
        spawn here --> Event(name=name, date=date, guests=guests);
        report "Event created: " + name + " on " + date + " for " + str(guests) + " guests.";
        ChecklistAgent.generate_checklist(name, guests);
    }
}

agent ChecklistAgent {
    can generate_checklist(str name, int guests) {
        mtllm ask "Generate a checklist for organizing an event called " + name + " for " + str(guests) + " people. Return 10 lines as plain lines." -> str checklist_text;
        report "Checklist from MTLLM:\n" + checklist_text;

        for line in checklist_text.split("\n") {
            if (line != "") {
                spawn here --> ChecklistItem(description=line);
            }
        }

        PriorityAgent.assign_priorities;
    }
}

agent PriorityAgent {
    can assign_priorities {
        for {has description} in here.out(ChecklistItem) {
            str desc = .description;
            mtllm ask "Assign a priority (1=low, 10=high) for this task: " + desc -> str p;
            .priority = int(p);
            report "Priority " + p + " set for: " + desc;
        }
    }
}

# ========== WALKER TO START THE FLOW ==========

walker start_planner {
    can start {
        EventAgent.create_event("birthday party", "2025-09-29", 10);
    }
}
