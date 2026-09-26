"""Entry point - registers every server endpoint the client calls, then
exports the file-based-routing client shell (see pages/)."""

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

def:pub app(children: any) -> JsxElement {
    return <>{children}</>;
}
