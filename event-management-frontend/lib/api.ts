const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://0.0.0.0:8000"

export interface User {
  id: string
  email: string
  name: string
}

export interface Event {
  id: string
  user_id: string
  name: string
  no_of_guests: string
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
  return apiRequest("/auth/login", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  })
}

export async function registerUser(name: string, email: string, password: string): Promise<User> {
  return apiRequest("/auth/register", {
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
  return apiRequest("/walker/create_event", {
    method: "POST",
    body: JSON.stringify(eventData),
  })
}

export async function getEvents(): Promise<Event[]> {
  return apiRequest("/walker/get_events")
}

export async function getEvent(eventId: string): Promise<Event> {
  return apiRequest(`/events/${eventId}`)
}

export async function updateEvent(eventId: string, eventData: UpdateEventData): Promise<Event> {
  return apiRequest(`/events/${eventId}`, {
    method: "PUT",
    body: JSON.stringify(eventData),
  })
}

export async function deleteEvent(eventId: DeleteEvent): Promise<void> {
  await apiRequest(`/events/${eventId}`, {
    method: "DELETE",
    body:JSON.stringify(deleteEvent)
  })
}
