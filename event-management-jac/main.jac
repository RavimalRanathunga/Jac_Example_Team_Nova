"""Entry point - registers every server endpoint the client calls, then
exports the manual-routing client shell (see routes/AppShell.jac).

Routing is manual (react-router `<Router>/<Routes>`), not the file-based
`pages/` convention: every shipped jac-client example (littleX, day_planner,
todo_app, mini_todo) uses manual routing, and this keeps the app on that
proven path rather than the newer, less-exercised file-based router."""

import from profile.store { Profile, save_profile, get_profile }
import from events.store {
    Event,
    create_event,
    list_events,
    get_event,
    update_event,
    delete_event
}

import "./global.css";
import from .routes.AppShell { AppShell }

def:pub app() -> JsxElement {
    return <AppShell/>;
}
