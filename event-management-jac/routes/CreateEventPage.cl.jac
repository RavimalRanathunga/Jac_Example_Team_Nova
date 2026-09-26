import from "@jac/runtime" { Link, useNavigate }
sv import from ..events.store { create_event }
import from ..components.AppHeader { AppHeader }

def:pub CreateEventPage() -> JsxElement {
    has name: str = "",
        event_type: str = "",
        guests: str = "",
        error: str = "",
        loading: bool = False;

    nav = useNavigate();

    async def handleSubmit -> None;

    return <div className="min-h-screen bg-secondary/20">
        <AppHeader title="Create New Event">
            <Link to="/dashboard">
                <button className="rounded-md border border-border px-4 py-2 text-sm font-medium hover:bg-secondary">
                    Back to Dashboard
                </button>
            </Link>
        </AppHeader>

        <main className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8">
            <div className="rounded-lg border border-border bg-card p-8 shadow-sm">
                <h2 className="text-lg font-semibold">Create New Event</h2>
                <p className="mb-6 text-muted-foreground">Fill in the details for your new event</p>

                {if error {
                    <div className="mb-4 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive">
                        {error}
                    </div>
                }}

                <form
                    className="flex flex-col gap-6"
                    onSubmit={lambda (e: FormEvent) {
                        e.preventDefault();
                        handleSubmit();
                    }}
                >
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-medium" htmlFor="name">Event Name</label>
                        <input
                            id="name"
                            className="rounded-md border border-border px-3 py-2 text-sm"
                            placeholder="Enter event name"
                            value={name}
                            onChange={lambda (e: ChangeEvent) { name = e.target.value; }}
                            required={True}
                        />
                    </div>
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-medium" htmlFor="event_type">Event Type</label>
                        <input
                            id="event_type"
                            className="rounded-md border border-border px-3 py-2 text-sm"
                            placeholder="e.g., Wedding, Birthday Party"
                            value={event_type}
                            onChange={lambda (e: ChangeEvent) { event_type = e.target.value; }}
                            required={True}
                        />
                    </div>
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-medium" htmlFor="guests">No of Guests</label>
                        <input
                            id="guests"
                            className="rounded-md border border-border px-3 py-2 text-sm"
                            placeholder="2, 10, 20, ..."
                            value={guests}
                            onChange={lambda (e: ChangeEvent) { guests = e.target.value; }}
                            required={True}
                        />
                    </div>
                    <div className="flex gap-4">
                        <button
                            type="submit"
                            className="flex-1 rounded-md bg-primary py-2 font-medium text-primary-foreground hover:opacity-90 disabled:opacity-60"
                            disabled={loading}
                        >
                            {"Creating Event..." if loading else "Create Event"}
                        </button>
                        <Link to="/dashboard">
                            <button type="button" className="rounded-md border border-border px-4 py-2 font-medium hover:bg-secondary">
                                Cancel
                            </button>
                        </Link>
                    </div>
                </form>
            </div>
        </main>
    </div>;
}

impl CreateEventPage.handleSubmit -> None {
    error = "";
    if not name.strip() or not event_type.strip() or not guests.strip() {
        error = "Please fill in all fields";
        return;
    }
    loading = True;
    try {
        event = await create_event(name, guests, event_type);
        loading = False;
        nav(f"/events/{jid(event)}");
    } except Exception {
        loading = False;
        error = "Failed to create event";
    }
}
