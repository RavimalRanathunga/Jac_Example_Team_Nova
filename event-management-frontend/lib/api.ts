const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000"

export interface User {
  id: string
  email: string
  username: string
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
  })

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({ message: "An error occurred" }))
    throw new ApiError(errorData.message || "An error occurred", response.status)
  }

  return response.json()
}

// Auth API calls
export async function loginUser(email: string, password: string): Promise<User> {
  const res = await apiRequest("/walker/login", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  })

  const userId = res?.reports?.[0]?.data?.context.id
  if (!userId) {
    throw new Error("Login failed: user ID not found in response")
  }

  localStorage.setItem("user_id", userId)
  localStorage.setItem("username", res?.reports?.[0]?.data?.context.username)
  // Optionally fetch full user details using the ID if needed
  return { id: userId, email, username: res?.reports?.[0]?.data?.context.username } // <- use actual name/email if returned separately
}


export async function registerUser(username: string, email: string, password: string): Promise<User> {
  const res = await apiRequest("/walker/register", {
    method: "POST",
    body: JSON.stringify({ username, email, password }),
  })

  const userId = res?.reports?.[0]?.data?.context.id
  if (!userId) {
    throw new Error("Registration failed: user ID not found in response")
  }

  localStorage.setItem("user_id", userId)

  return { id: userId, email,username}
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
  await apiRequest("/walker/logout", {
    method: "POST",
  })
}

// Event API calls
export async function createEvent(eventData: CreateEventData): Promise<Event | null> {
  const created_by = localStorage.getItem("user_id")

  if (!created_by) {
    throw new Error("User ID not found. User might not be logged in.")
  }

  const fullEventData = {
    ...eventData,
    created_by,
  }

  const res = await apiRequest("/walker/create_event", {
    method: "POST",
    body: JSON.stringify(fullEventData),
  })

  if(res && res?.reports?.[0]?.data?.context)
  {
    console.log(res)
    console.log("hi")
    return res?.reports?.[0]?.data?.context
  }
  return null;
}

export async function getEvents(): Promise<Event[]> {
  const created_by = localStorage.getItem("user_id")

  const res = await apiRequest("/walker/get_events", {
    method: "POST",
    body:JSON.stringify({created_by:created_by})
  })

  // Make sure you extract .context from each item in reports[0].data
  const rawEvents = res?.reports?.[0]?.data || []

  // Map each item to its .context, and also include the top-level id for routing
  const events = rawEvents.map((item: any) => ({
    id: item.context.id, // or item.id if needed for routes
    ...item.context,
  }))

  return events
}

export async function getEvent(eventId: GetEvent): Promise<Event|null> {
  const res = await apiRequest(`/walker/get_event`,{
    method:"POST",
    body:JSON.stringify(eventId)
  })

  if(res && res?.reports?.[0]?.data?.context)
  {
    return res?.reports?.[0]?.data?.context
  }
  return null;
}

export async function updateEvent(eventId: string, eventData: UpdateEventData): Promise<Event> {
  return apiRequest(`/walker/update_event`, {
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
