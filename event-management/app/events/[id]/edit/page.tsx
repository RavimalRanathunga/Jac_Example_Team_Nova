"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { getEvent, updateEvent } from "@/lib/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Alert, AlertDescription } from "@/components/ui/alert"
import Link from "next/link"
import { ArrowLeft } from "lucide-react"

export default function EditEventPage({ params }: { params: { id: string } }) {
  const [formData, setFormData] = useState({
    name: "",
    no_of_guests: "",
    event_type: "",
    budget: "",
    checklist: "",
  })
  const [error, setError] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [isLoadingEvent, setIsLoadingEvent] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const loadEvent = async () => {
      try {
        const eventId ={event_id:params.id}
        const event = await getEvent(eventId)
        setFormData({
          name: event.name,
          no_of_guests: event.no_of_guests.toString(),
          event_type: event.event_type,
          budget: event.budget.toString(),
          checklist: event.checklist.join("\n"),
        })
      } catch (error) {
        setError("Failed to load event")
      } finally {
        setIsLoadingEvent(false)
      }
    }

    loadEvent()
  }, [params.id])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError("")
    setIsLoading(true)

    try {
      const checklist = formData.checklist
        .split("\n")
        .map((item) => item.trim())
        .filter((item) => item.length > 0)

      const eventData = {
        name: formData.name,
        no_of_guests: formData.no_of_guests,
        event_type: formData.event_type,
        checklist,
        budget: Number.parseFloat(formData.budget),
        event_id:params.id
      }

      await updateEvent(params.id, eventData)
      router.push(`/events/${params.id}`)
    } catch (error: any) {
      setError(error.message || "Failed to update event")
    } finally {
      setIsLoading(false)
    }
  }

  const handleInputChange = (field: string, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }))
  }

  if (isLoadingEvent) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div>Loading...</div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center py-4">
            <Link href={`/events/${params.id}`}>
              <Button variant="ghost" size="sm">
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Event
              </Button>
            </Link>
          </div>
        </div>
      </header>

      <main className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Card>
          <CardHeader>
            <CardTitle>Edit Event</CardTitle>
            <CardDescription>Update the details for your event</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}

              <div className="space-y-2">
                <Label htmlFor="name">Event Name</Label>
                <Input
                  id="name"
                  placeholder="Enter event name"
                  value={formData.name}
                  onChange={(e) => handleInputChange("name", e.target.value)}
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="no_of_guests">Number of Guests</Label>
                  <Input
                    id="no_of_guests"
                    type="number"
                    min="1"
                    value={formData.no_of_guests}
                    onChange={(e) => handleInputChange("no_of_guests", e.target.value)}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="budget">Budget ($)</Label>
                  <Input
                    id="budget"
                    type="number"
                    min="0"
                    step="0.01"
                    value={formData.budget}
                    onChange={(e) => handleInputChange("budget", e.target.value)}
                    required
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="event_type">Event Type</Label>
                <Input
                  id="event_type"
                  type="text"
                  placeholder="e.g., Wedding, Birthday Party"
                  value={formData.event_type}
                  onChange={(e) => handleInputChange("event_type", e.target.value)}
                  required
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="checklist">Checklist</Label>
                <Textarea
                  id="checklist"
                  placeholder="Enter checklist items (one per line)"
                  rows={6}
                  value={formData.checklist}
                  onChange={(e) => handleInputChange("checklist", e.target.value)}
                />
                <p className="text-sm text-gray-600">Enter each checklist item on a new line</p>
              </div>

              <div className="flex gap-4">
                <Button type="submit" className="flex-1" disabled={isLoading}>
                  {isLoading ? "Updating Event..." : "Update Event"}
                </Button>
                <Link href={`/events/${params.id}`}>
                  <Button type="button" variant="outline">
                    Cancel
                  </Button>
                </Link>
              </div>
            </form>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}
