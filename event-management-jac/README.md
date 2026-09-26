# Event Manager (Jac 0.34.17, jac-client full-stack)

A full-stack rewrite of the original Next.js + Jaseci event management platform,
built entirely in Jac using the modern single-binary `jac` toolchain (frontend,
backend, persistence, auth and AI in one language, one project).

## Features

- Email/password authentication (built-in `jac` auth: signup, login, logout,
  per-user JWT sessions, per-user graph isolation - no more manually filtering
  events by a `created_by` field sent from the browser)
- Create, list, view, edit and delete events
- AI-generated planning checklist and budget suggestion per event (`by llm()`,
  Gemini by default)
- Dashboard, create-event form, and a per-event detail/edit page
- File-based routing with an automatic auth guard on every page under
  `pages/(auth)/`

## Project layout

```
event-management-jac/
├── jac.toml              # project + client + byllm config
├── main.jac               # entry point - registers every server endpoint
├── global.css              # Tailwind v4 theme
├── lib/utils.jac           # cn() class-merging helper
├── events/store.jac        # Event node, byllm functions, CRUD endpoints
├── profile/store.jac       # per-user display-name Profile node
├── components/             # shared client components (header, event card)
└── pages/                  # file-based routes
    ├── layout.jac
    ├── index.jac            # /            - landing page
    ├── (public)/
    │   ├── login.jac        # /login
    │   └── signup.jac       # /signup
    └── (auth)/              # every page below requires a login (auto-guarded)
        ├── dashboard.jac    # /dashboard
        ├── create-event.jac # /create-event
        └── events/[id].jac  # /events/:id
```

## Running

Requires the `jac` binary (v0.34.17) - see
<https://github.com/jaseci-labs/jaseci#readme> or
`curl -fsSL https://raw.githubusercontent.com/jaseci-labs/jaseci/main/scripts/install.sh | bash -s -- --version 0.34.17`.

```bash
cd event-management-jac
export GOOGLE_API_KEY=...     # for the AI checklist/budget suggestions
jac install
jac start --dev main.jac
```

Then open <http://localhost:8000>.

> **Note:** this project was authored against the documented Jac 0.34.17
> language/toolchain surface, but could not be executed inside the sandbox
> this migration was written in (installing/running the `jac` binary is
> blocked there). Run `jac check .` and `jac start --dev main.jac` locally
> before relying on it, and please report anything that doesn't compile.
