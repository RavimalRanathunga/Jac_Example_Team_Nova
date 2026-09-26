import from "@jac/runtime" { Link }

def:pub Feature(title: str, description: str) -> JsxElement {
    return <div className="rounded-lg border border-border bg-card p-6 shadow-sm">
        <h3 className="mb-2 text-lg font-semibold">{title}</h3>
        <p className="text-sm text-muted-foreground">{description}</p>
    </div>;
}

def:pub Home() -> JsxPage {
    return <div className="bg-gradient-to-br from-indigo-50 to-blue-100 min-h-screen">
        <div className="mx-auto max-w-6xl px-4 py-16">
            <div className="mb-16 text-center">
                <h1 className="mb-6 text-4xl font-bold text-gray-900 md:text-6xl">
                    Event Manager
                </h1>
                <p className="mx-auto mb-8 max-w-2xl text-xl text-gray-600">
                    Plan, organize, and manage your events with ease. Keep track of guests, budgets, and checklists all in one place.
                </p>
                <div className="flex justify-center gap-4">
                    <Link to="/signup">
                        <button className="rounded-md bg-primary px-8 py-3 font-medium text-primary-foreground hover:opacity-90">
                            Get Started
                        </button>
                    </Link>
                    <Link to="/login">
                        <button className="rounded-md border border-border bg-transparent px-8 py-3 font-medium hover:bg-secondary">
                            Sign In
                        </button>
                    </Link>
                </div>
            </div>

            <div className="mx-auto grid max-w-6xl gap-6 md:grid-cols-2 lg:grid-cols-4">
                <Feature
                    title="Event Planning"
                    description="Create and organize events with detailed information and planning tools."
                />
                <Feature
                    title="Guest Management"
                    description="Keep track of guest counts and manage attendee information efficiently."
                />
                <Feature
                    title="Budget Tracking"
                    description="AI suggests a budget for your event and keeps expenses under control."
                />
                <Feature
                    title="Task Checklists"
                    description="AI generates a checklist so nothing about your event is forgotten."
                />
            </div>
        </div>
    </div>;
}
