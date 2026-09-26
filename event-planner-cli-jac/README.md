# Event Planner Assistant CLI (Jac 0.34.17)

A migrated, consolidated rewrite of the original `event-planner-assistant`
tutorial steps (step-2 through step-6), built against the modern single-binary
`jac` toolchain. It merges the manual checklist manager (step-5) and the
LLM-powered assistant (step-6) into one menu-driven CLI.

## Features

- Create an event and optionally attach a manual checklist (with priorities)
- Create an event with the AI assistant: analyzes the event, generates a
  checklist, and suggests a budget with `by llm()`
- View all previously created events and their checklists

## Running

Requires the `jac` binary (v0.34.17):

```bash
cd event-planner-cli-jac
export GOOGLE_API_KEY=...   # for the AI assistant option
jac run main.jac
```

> **Note:** authored against the documented Jac 0.34.17 syntax but not
> executable inside the sandbox this migration was written in - please run
> `jac check main.jac` and `jac run main.jac` locally to verify.
