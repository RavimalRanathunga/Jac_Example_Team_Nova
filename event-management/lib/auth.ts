import { cookies } from "next/headers"
import { redirect } from "next/navigation"
import { getCurrentUser, type User } from "./api"

// Note: JWT_SECRET is no longer directly used for session creation/verification
// in the frontend, as session management is now handled by the Python backend.
// It's kept here for potential future use or if parts of the auth logic
// were to be re-introduced on the Next.js side.
const JWT_SECRET = new TextEncoder().encode(process.env.JWT_SECRET || "your-secret-key-at-least-32-characters-long")

export async function getSession(): Promise<User | null> {
  try {
    return await getCurrentUser()
  } catch (error) {
    return null
  }
}

export async function deleteSession() {
  const cookieStore = await cookies()
  cookieStore.delete("session")
}

export async function requireAuth(): Promise<User> {
  const user = await getSession()
  if (!user) {
    redirect("/login")
  }
  return user
}

export type { User }
