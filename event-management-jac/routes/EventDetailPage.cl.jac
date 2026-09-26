import from "@jac/runtime" { Link, useNavigate, useParams }
sv import from ..events.store { Event, get_event, update_event, delete_event }
import from ..components.AppHeader { AppHeader }

def:pub EventDetailPage() -> JsxElement {
    has event: Event | None = None,
        loading: bool = True,
        notFound: bool = False,
        editing: bool = False,
        editName: str = "",
        editType: str = "",
        editGuests: str = "",
        editBudget: str = "",
        editChecklist: str = "",
        saving: bool = False,
        deleting: bool = False;

    params = useParams();
    eventId: str = params["id"] or "";
    nav = useNavigate();

    async can with entry {
        loadEvent();
    }

    async def loadEvent -> None;
    def startEdit -> None;
    async def saveEdit -> None;
    async def handleDelete -> None;

    if loading {
        return <div className="flex min-h-screen items-center justify-center text-muted-foreground">
            Loading...
        </div>;
    }

    if notFound or event is None {
        return <div className="flex min-h-screen flex-col items-center justify-center gap-4">
            <p className="text-lg font-medium">Event not found</p>
            <Link to="/dashboard">
                <button className="rounded-md border border-border px-4 py-2 text-sm font-medium hover:bg-secondary">
                    Back to Dashboard
                </button>
            </Link>
        </div>;
    }

    return <div className="min-h-screen bg-secondary/20">
        <AppHeader title={event.event_name} subtitle={event.event_type}>
            <Link to="/dashboard">
                <button className="rounded-md border border-border px-4 py-2 text-sm font-medium hover:bg-secondary">
                    Back to Dashboard
                </button>
            </Link>
        </AppHeader>

        <main className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8">
            <div className="rounded-lg border border-border bg-card p-8 shadow-sm">
                {if not editing {
                    <div className="flex flex-col gap-6">
                        <div className="grid grid-cols-2 gap-4 text-sm">
                            <div>
                                <div className="text-muted-foreground">Guests</div>
                                <div className="font-medium">{event.number_of_guests}</div>
                            </div>
                            <div>
                                <div className="text-muted-foreground">Budget</div>
                                <div className="font-medium">${event.budget}</div>
                            </div>
                            <div>
                                <div className="text-muted-foreground">Created</div>
                                <div className="font-medium">{event.created_at}</div>
                            </div>
                            <div>
                                <div className="text-muted-foreground">Updated</div>
                                <div className="font-medium">{event.updated_at}</div>
                            </div>
                        </div>

                        <div>
                            <h3 className="mb-2 text-sm font-semibold">Checklist</h3>
                            <ul className="flex flex-col gap-2">
                                {for item in event.checklist {
                                    <li className="rounded-md border border-border px-3 py-2 text-sm">
                                        {item}
                                    </li>
                                }}
                            </ul>
                        </div>

                        <div className="flex gap-4">
                            <button
                                className="flex-1 rounded-md bg-primary py-2 font-medium text-primary-foreground hover:opacity-90"
                                onClick={startEdit}
                            >
                                Edit Event
                            </button>
                            <button
                                className="rounded-md bg-destructive px-4 py-2 font-medium text-destructive-foreground hover:opacity-90 disabled:opacity-60"
                                disabled={deleting}
                                onClick={handleDelete}
                            >
                                {"Deleting..." if deleting else "Delete"}
                            </button>
                        </div>
                    </div>
                } else {
                    <div className="flex flex-col gap-4">
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-medium">Event Name</label>
                            <input
                                className="rounded-md border border-border px-3 py-2 text-sm"
                                value={editName}
                                onChange={lambda (e: ChangeEvent) { editName = e.target.value; }}
                            />
                        </div>
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-medium">Event Type</label>
                            <input
                                className="rounded-md border border-border px-3 py-2 text-sm"
                                value={editType}
                                onChange={lambda (e: ChangeEvent) { editType = e.target.value; }}
                            />
                        </div>
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-medium">No of Guests</label>
                            <input
                                className="rounded-md border border-border px-3 py-2 text-sm"
                                value={editGuests}
                                onChange={lambda (e: ChangeEvent) { editGuests = e.target.value; }}
                            />
                        </div>
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-medium">Budget (USD)</label>
                            <input
                                className="rounded-md border border-border px-3 py-2 text-sm"
                                value={editBudget}
                                onChange={lambda (e: ChangeEvent) { editBudget = e.target.value; }}
                            />
                        </div>
                        <div className="flex flex-col gap-2">
                            <label className="text-sm font-medium">Checklist (one item per line)</label>
                            <textarea
                                className="min-h-32 rounded-md border border-border px-3 py-2 text-sm"
                                value={editChecklist}
                                onChange={lambda (e: ChangeEvent) { editChecklist = e.target.value; }}
                            />
                        </div>
                        <div className="flex gap-4">
                            <button
                                className="flex-1 rounded-md bg-primary py-2 font-medium text-primary-foreground hover:opacity-90 disabled:opacity-60"
                                disabled={saving}
                                onClick={saveEdit}
                            >
                                {"Saving..." if saving else "Save Changes"}
                            </button>
                            <button
                                className="rounded-md border border-border px-4 py-2 font-medium hover:bg-secondary"
                                onClick={lambda { editing = False; }}
                            >
                                Cancel
                            </button>
                        </div>
                    </div>
                }}
            </div>
        </main>
    </div>;
}

impl EventDetailPage.loadEvent -> None {
    loading = True;
    if not eventId {
        notFound = True;
        loading = False;
        return;
    }
    result = await get_event(eventId);
    event = result;
    notFound = result is None;
    loading = False;
}

impl EventDetailPage.startEdit -> None {
    if event is None {
        return;
    }
    editName = event.event_name;
    editType = event.event_type;
    editGuests = event.number_of_guests;
    editBudget = str(event.budget);
    editChecklist = "\n".join(event.checklist);
    editing = True;
}

impl EventDetailPage.saveEdit -> None {
    saving = True;
    budgetValue: float = float(editBudget) if editBudget.strip() else 0.0;
    checklistItems = [
        line.strip()
        for line in editChecklist.split("\n")
        if line.strip()
    ];
    updated = await update_event(
        eventId,
        name=editName,
        guests=editGuests,
        event_type=editType,
        checklist=checklistItems,
        budget=budgetValue
    );
    event = updated if updated else event;
    saving = False;
    editing = False;
}

impl EventDetailPage.handleDelete -> None {
    deleting = True;
    await delete_event(eventId);
    deleting = False;
    nav("/dashboard");
}
