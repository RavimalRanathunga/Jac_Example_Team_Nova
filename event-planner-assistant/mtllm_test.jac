import from mtllm.llms {Gemini}

glob llm = Gemini(model_name="gemini-2.0-flash");

def get_joke_with_punchline() -> tuple[str, str] by llm();

with entry {
    (joke, punchline) = get_joke_with_punchline();
    print(f"{joke}: {punchline}");
}