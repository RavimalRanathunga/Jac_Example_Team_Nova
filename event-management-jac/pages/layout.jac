import from "@jac/runtime" { Outlet }

def:pub RootLayout() -> JsxLayout {
    return <div className="min-h-screen bg-background text-foreground">
        <Outlet/>
    </div>;
}
