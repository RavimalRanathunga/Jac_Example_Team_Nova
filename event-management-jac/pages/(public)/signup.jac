import from "@jac/runtime" { jacSignup, jacLogin, useNavigate, Link }
sv import from ...profile.store { save_profile }

def:pub SignupPage() -> JsxPage {
    has username: str = "",
        email: str = "",
        password: str = "",
        error: str = "",
        loading: bool = False;

    nav = useNavigate();

    async def handleSubmit -> None;

    return <div className="flex min-h-screen items-center justify-center bg-secondary/40 px-4">
        <div className="w-full max-w-md rounded-lg border border-border bg-card p-8 shadow-sm">
            <h1 className="text-2xl font-bold">Create Account</h1>
            <p className="mb-6 text-muted-foreground">Sign up to start managing your events</p>

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
                    <label className="text-sm font-medium" htmlFor="username">Full Name</label>
                    <input
                        id="username"
                        type="text"
                        className="rounded-md border border-border px-3 py-2 text-sm"
                        placeholder="Enter your full name"
                        value={username}
                        onChange={lambda (e: ChangeEvent) { username = e.target.value; }}
                        required={True}
                    />
                </div>
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
                    {"Creating Account..." if loading else "Create Account"}
                </button>
            </form>

            <div className="mt-4 text-center text-sm text-muted-foreground">
                {"Already have an account? "}
                <Link to="/login" className="font-medium text-primary hover:underline">Sign in</Link>
            </div>
        </div>
    </div>;
}

impl SignupPage.handleSubmit -> None {
    error = "";
    if len(password) < 6 {
        error = "Password must be at least 6 characters";
        return;
    }
    if not username.strip() {
        error = "Please enter your full name";
        return;
    }
    loading = True;

    signup_result: dict | None = None;
    login_ok: bool = False;
    profile_result: any = None;

    try {
        signup_result = await jacSignup(email, password);
        if not signup_result["success"] {
            loading = False;
            error = str(signup_result["error"] if signup_result["error"] else "Registration failed");
            return;
        }

        login_ok = await jacLogin(email, password);
        if not login_ok {
            loading = False;
            error = "Account created. Please log in.";
            nav("/login");
            return;
        }

        profile_result = await save_profile(username);
    } except Exception {
        loading = False;
        error = "Registration failed";
        return;
    }

    loading = False;
    nav("/dashboard");
}
