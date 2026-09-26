import from "@jac/runtime" { Router, Routes, Route, Navigate, AuthGuard }
import from .HomePage { HomePage }
import from .LoginPage { LoginPage }
import from .SignupPage { SignupPage }
import from .DashboardPage { DashboardPage }
import from .CreateEventPage { CreateEventPage }
import from .EventDetailPage { EventDetailPage }

def:pub AppShell() -> JsxElement {
    return <Router>
        <Routes>
            <Route path="/" element={<HomePage/>}/>
            <Route path="/login" element={<LoginPage/>}/>
            <Route path="/signup" element={<SignupPage/>}/>
            <Route element={<AuthGuard redirect="/login"/>}>
                <Route path="/dashboard" element={<DashboardPage/>}/>
                <Route path="/create-event" element={<CreateEventPage/>}/>
                <Route path="/events/:id" element={<EventDetailPage/>}/>
            </Route>
            <Route path="*" element={<Navigate to="/" replace={True}/>}/>
        </Routes>
    </Router>;
}
