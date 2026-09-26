"""Shared top bar for authenticated pages - title/subtitle on the left,
arbitrary action buttons (passed as children) on the right."""

def:pub AppHeader(title: str, subtitle: str = "", children: any = None) -> JsxElement {
    return <header className="border-b border-border bg-card shadow-sm">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
            <div>
                <h1 className="text-2xl font-bold">{title}</h1>
                {if subtitle {
                    <p className="text-muted-foreground">{subtitle}</p>
                }}
            </div>
            <div className="flex items-center gap-3">
                {children}
            </div>
        </div>
    </header>;
}
