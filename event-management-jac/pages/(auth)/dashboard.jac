import from "@jac/runtime" { jacLogout, useNavigate, Link }
sv import from ...events.store { Event, list_events }
sv import from ...profile.store { get_profile }
import from ...components.AppHeader { AppHeader }
import from ...components.EventCard { EventCard }

def:pub DashboardPage() -> JsxPage {
    has events: list[Event] = [],
        username: str = "",
        loading: bool = True;

    nav = useNavigate();

    async can with entry {
        loadData();
    }

    async def loadData -> None;
    def handleLogout -> None;

    return <div className="min-h-screen bg-secondary/20">
        <AppHeader title="Event Manager" subtitle={f"Welcome back, {username}"}>
            <Link to="/create-event">
                <button className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:opacity-90">
                    + Create Event
                </button>
            </Link>
            <button
                className="rounded-md border border-border px-4 py-2 text-sm font-medium hover:bg-secondary"
                onClick={handleLogout}
            >
                Log Out
            </button>
        </AppHeader>

        <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
            <h2 className="mb-4 text-xl font-semibold">Your Events</h2>

            {if loading {
                <div className="py-12 text-center text-muted-foreground">Loading...</div>
            } elif len(events) == 0 {
                <div className="flex flex-col items-center justify-center rounded-lg border border-border bg-card py-12">
                    <h3 className="mb-2 text-lg font-medium">No events yet</h3>
                    <p className="mb-4 text-muted-foreground">Get started by creating your first event</p>
                    <Link to="/create-event">
                        <button className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:opacity-90">
                            + Create Your First Event
                        </button>
                    </Link>
                </div>
            } else {
                <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                    {for event in events {
                        <EventCard key={jid(event)} event={event}/>
                    }}
                </div>
            }}
        </main>
    </div>;
}

impl DashboardPage.loadData -> None {
    loading = True;
    profileResult = await get_profile();
    username = profileResult.username if profileResult else "";
    events = await list_events();
    loading = False;
}

impl DashboardPage.handleLogout -> None {
    jacLogout();
    nav("/login");
}
