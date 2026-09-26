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
- Everything runs as **one single service** - no sv-to-sv microservices

## Project layout

```
event-management-jac/
├── jac.toml                    # project + client + byllm config
├── main.jac                     # entry point - registers every server endpoint
├── global.css                    # Tailwind v4 theme
├── lib/utils.jac                 # cn() class-merging helper
├── events/store.sv.jac           # Event node, byllm functions, CRUD endpoints
├── profile/store.sv.jac          # per-user display-name Profile node
├── components/                   # shared client components (header, event card)
│   ├── AppHeader.cl.jac
│   └── EventCard.cl.jac
└── routes/                       # manual routing - one component per route
    ├── AppShell.cl.jac            # <Router><Routes>...</Routes></Router> + AuthGuard
    ├── HomePage.cl.jac            # /
    ├── LoginPage.cl.jac           # /login
    ├── SignupPage.cl.jac          # /signup
    ├── DashboardPage.cl.jac       # /dashboard          (behind AuthGuard)
    ├── CreateEventPage.cl.jac     # /create-event       (behind AuthGuard)
    └── EventDetailPage.cl.jac     # /events/:id         (behind AuthGuard)
```

Two things are pinned explicitly rather than left to inference, matching the
`jac create --kind web-app` default scaffold exactly:

- **Routing is manual** (`<Router>/<Routes>` from `@jac/runtime`, guarded with
  `<AuthGuard>`) - every shipped jac-client example (littleX, day_planner,
  todo_app, mini_todo) uses manual routing rather than the newer file-based
  `pages/` convention, so this keeps the app on that proven path.
- **Every server module is an explicit `.sv.jac` file, every client module
  that `sv import`s it is an explicit `.cl.jac` file** (`main.jac`'s client
  section is wrapped in an explicit `cl { ... }` block too). `sv import` from
  a module the compiler infers as *server* is a **different mechanism** than
  from a module it infers as *client*: server-to-server `sv import` spawns
  the imported module as its own sibling microservice process, while
  client-to-server `sv import` is the normal in-process browser-to-backend
  RPC call. An early version of this project left codespace placement to
  inference and got `events`/`profile` `store.jac` registered as sibling
  microservices instead of running as part of the one app process. Explicit
  `.sv.jac`/`.cl.jac` extensions (the same pattern the default `web-app`
  scaffold's `endpoints.sv.jac` + `frontend.cl.jac` use) remove that
  ambiguity entirely.

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
