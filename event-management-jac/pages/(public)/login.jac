import from "@jac/runtime" { jacLogin, useNavigate, Link }

def:pub LoginPage() -> JsxPage {
    has email: str = "",
        password: str = "",
        error: str = "",
        loading: bool = False;

    nav = useNavigate();

    async def handleSubmit -> None;

    return <div className="flex min-h-screen items-center justify-center bg-secondary/40 px-4">
        <div className="w-full max-w-md rounded-lg border border-border bg-card p-8 shadow-sm">
            <h1 className="text-2xl font-bold">Sign In</h1>
            <p className="mb-6 text-muted-foreground">Enter your credentials to access your account</p>

            {if error {
                <div className="mb-4 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive">
                    {error}
                </div>
            }}

            <form
                className="flex flex-col gap-4"
                onSubmit={lambda (e: FormEvent) {
                    e.preventDefault();
                    handleSubmit();
                }}
            >
                <div className="flex flex-col gap-2">
                    <label className="text-sm font-medium" htmlFor="email">Email</label>
                    <input
                        id="email"
                        type="email"
                        className="rounded-md border border-border px-3 py-2 text-sm"
                        placeholder="Enter your email"
                        value={email}
                        onChange={lambda (e: ChangeEvent) { email = e.target.value; }}
                        required={True}
                    />
                </div>
                <div className="flex flex-col gap-2">
                    <label className="text-sm font-medium" htmlFor="password">Password</label>
                    <input
                        id="password"
                        type="password"
                        className="rounded-md border border-border px-3 py-2 text-sm"
                        placeholder="Enter your password"
                        value={password}
                        onChange={lambda (e: ChangeEvent) { password = e.target.value; }}
                        required={True}
                    />
                </div>
                <button
                    type="submit"
                    className="rounded-md bg-primary py-2 font-medium text-primary-foreground hover:opacity-90 disabled:opacity-60"
                    disabled={loading}
                >
                    {"Signing In..." if loading else "Sign In"}
                </button>
            </form>

            <div className="mt-4 text-center text-sm text-muted-foreground">
                {"Don't have an account? "}
                <Link to="/signup" className="font-medium text-primary hover:underline">Sign up</Link>
            </div>
        </div>
    </div>;
}

impl LoginPage.handleSubmit -> None {
    error = "";
    loading = True;
    ok: bool = False;
    try {
        ok = await jacLogin(email, password);
    } except Exception {
        ok = False;
    }
    loading = False;
    if ok {
        nav("/dashboard");
    } else {
        error = "Invalid email or password";
    }
}
