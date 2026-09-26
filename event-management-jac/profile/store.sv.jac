"""Per-user display profile - just a username alongside the built-in auth
identity (email/password are handled by the platform's auth system, not
stored here)."""

node Profile {
    has username: str = "";
}

def:priv save_profile(username: str) -> Profile {
    existing = [root -->][?:Profile];
    if existing {
        existing[0].username = username;
        return existing[0];
    }
    return root ++> Profile(username=username);
}

def:priv get_profile() -> Profile | None {
    existing = [root -->][?:Profile];
    if existing {
        return existing[0];
    }
    return None;
}
