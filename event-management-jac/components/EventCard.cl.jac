import from "@jac/runtime" { Link }
sv import from ..events.store { Event }

def:pub EventCard(event: Event) -> JsxElement {
    return <div className="rounded-lg border border-border bg-card p-6 shadow-sm transition-shadow hover:shadow-md">
        <div className="mb-1 flex items-start justify-between gap-2">
            <h3 className="text-lg font-semibold">{event.event_name}</h3>
            <span className="rounded-full bg-secondary px-3 py-1 text-xs font-medium text-secondary-foreground">
                {event.event_type}
            </span>
        </div>
        <p className="mb-4 text-sm text-muted-foreground">
            Created {event.created_at}
        </p>
        <div className="mb-4 flex flex-col gap-2 text-sm text-muted-foreground">
            <div>{event.number_of_guests} guests</div>
            <div>${event.budget}</div>
        </div>
        <Link to={f"/events/{jid(event)}"}>
            <button className="w-full rounded-md border border-border py-2 text-sm font-medium hover:bg-secondary">
                View Details
            </button>
        </Link>
    </div>;
}
