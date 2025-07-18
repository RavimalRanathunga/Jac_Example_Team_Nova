const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://0.0.0.0:8000"

export interface User {
  id: string
  email: string
  name: string
}

export interface Event {
  id: string
  created_by: string
  event_name: string
  number_of_guests: string
  event_type: string
  checklist: string[]
  budget: number
  created_at: string
  updated_at: string
}

export interface CreateEventData {
  name: string
  event_type: string
  guests:string
}

export interface UpdateEventData {
  name: string
  no_of_guests: string
  event_type: string
  checklist: string[]
  budget: number
  event_id:String
}

export interface DeleteEvent{
  event_id:string
}

export interface GetEvent{
  event_id:string
}

class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
  ) {
    super(message)
    this.name = "ApiError"
  }
}

async function apiRequest(endpoint: string, options: RequestInit = {}) {
  const url = `${API_BASE_URL}${endpoint}`

  const response = await fetch(url, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
    credentials: "include", // Include cookies for session management
  })

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({ message: "An error occurred" }))
    throw new ApiError(errorData.message || "An error occurred", response.status)
  }

  return response.json()
}

// Auth API calls
export async function loginUser(email: string, password: string): Promise<User> {
  const user = await apiRequest("/walker/login", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  })

  // Store user ID in localStorage
  localStorage.setItem("user_id", user.id)

  return user
}

export async function registerUser(name: string, email: string, password: string): Promise<User> {
  return apiRequest("/walker/register", {
    method: "POST",
    body: JSON.stringify({ name, email, password }),
  })
}

export async function getCurrentUser(): Promise<User | null> {
  try {
    return await apiRequest("/auth/me")
  } catch (error) {
    if (error instanceof ApiError && error.status === 401) {
      return null
    }
    throw error
  }
}

export async function logoutUser(): Promise<void> {
  await apiRequest("/auth/logout", {
    method: "POST",
  })
}

// Event API calls
export async function createEvent(eventData: CreateEventData): Promise<Event> {
  const user_id = localStorage.getItem("user_id")

  if (!user_id) {
    throw new Error("User ID not found. User might not be logged in.")
  }

  const fullEventData = {
    ...eventData,
    user_id,
  }

  return apiRequest("/walker/create_event", {
    method: "POST",
    body: JSON.stringify(fullEventData),
  })
}

export async function getEvents(): Promise<Event[]> {
  const user_id = localStorage.getItem("user_id")
  
  return apiRequest("/walker/get_events", {
    method: "POST",
    body: JSON.stringify({ user_id }), // Only if your backend needs it
  })
}

export async function getEvent(eventId: GetEvent): Promise<Event> {
  return apiRequest(`/walker/get_event`,{
    method:"POST",
    body:JSON.stringify(eventId)
  })
}

export async function updateEvent(eventId: string, eventData: UpdateEventData): Promise<Event> {
  return apiRequest(`/events/${eventId}`, {
    method: "PATCH",
    body: JSON.stringify(eventData),
  })
}

export async function deleteEvent(eventId: DeleteEvent): Promise<void> {
  await apiRequest(`/walker/delete_event`, {
    method: "DELETE",
    body:JSON.stringify(eventId)
  })
}
