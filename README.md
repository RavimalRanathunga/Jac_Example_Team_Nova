# Jac Example - Team Nova

Two Jac-language projects, both built on the modern single-binary `jac`
toolchain (v0.34.17) with jac-client full-stack: one language for frontend,
backend, persistence, auth and AI.

## Projects

### [`event-planner-cli-jac/`](event-planner-cli-jac/) — Event Planner Assistant (CLI)

A menu-driven command-line tool. Create an event with a manual checklist, or
hand it to an LLM assistant that analyzes the event, generates a checklist,
and suggests a budget. See its [README](event-planner-cli-jac/README.md) for
setup and usage.

### [`event-management-jac/`](event-management-jac/) — Event Manager (full-stack web app)

A full-stack event management platform: email/password authentication with
per-user data isolation, create/list/view/edit/delete events, and
AI-generated planning checklists and budget suggestions per event. See its
[README](event-management-jac/README.md) for setup and usage.

## Getting started

Both projects need the `jac` binary (v0.34.17):

```bash
curl -fsSL https://raw.githubusercontent.com/jaseci-labs/jaseci/main/scripts/install.sh | bash -s -- --version 0.34.17
```

Then follow the "Running" section in whichever project's README you want to
try.

## History

This repo previously shipped two other implementations of the same ideas,
built on the older pip-installed `jaclang`/`mtllm` packages plus a separate
Next.js frontend: a CLI tutorial series (`event-planner-assistant/`, steps
2-6) and a Next.js + Jaseci web app (`event-management-frontend/` +
`event-management-backend/`). Both have been fully migrated to the projects
above and removed; see the git history if you need to refer back to them.

## Authors

Built with ❤️ by **Team Nova**
