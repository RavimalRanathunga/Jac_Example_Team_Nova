import from mtllm.llms { Gemini }

glob llm = Gemini(model_name="gemini-2.0-flash", verbose=False);


node Event {
    has name: str;
    has date: str;
    has guests: int;
}

node ChecklistItem {
    has description: str;
    has priority: int = 0;
}


