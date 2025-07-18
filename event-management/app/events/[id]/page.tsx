import { requireAuth } from "@/lib/auth"
import { getEvent } from "@/lib/api"
import { notFound } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import Link from "next/link"
import { ArrowLeft, Edit, Users, CheckSquare } from "lucide-react"
import { DeleteEventButton } from "@/components/delete-event-button"

export default async function EventDetailsPage({ params }: { params: { id: string } }) {
  await requireAuth()

  let event
  try {
    const eventId ={
      event_id:params.id
    }
    event = await getEvent(eventId)
  } catch (error) {
    notFound()
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between py-4">
            <Link href="/dashboard">
              <Button variant="ghost" size="sm">
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Dashboard
              </Button>
            </Link>
            <div className="flex gap-2">
              <Link href={`/events/${event.id}/edit`}>
                <Button variant="outline" size="sm">
                  <Edit className="w-4 h-4 mr-2" />
                  Edit
                </Button>
              </Link>
              <DeleteEventButton eventId={event.id} />
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <div className="flex justify-between items-start">
                <div>
                  <CardTitle className="text-2xl">{event.event_name}</CardTitle>
                  <CardDescription>
                    Created on {new Date(event.created_at).toLocaleDateString()}
                    {event.updated_at !== event.created_at && (
                      <span> • Updated on {new Date(event.updated_at).toLocaleDateString()}</span>
                    )}
                  </CardDescription>
                </div>
                <Badge variant="secondary" className="text-sm">
                  {event.event_type}
                </Badge>
              </div>
            </CardHeader>
          </Card>

          <div className="grid gap-6 md:grid-cols-2">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center">
                  <Users className="w-5 h-5 mr-2" />
                  Event Details
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex justify-between">
                  <span className="text-gray-600">Number of Guests:</span>
                  <span className="font-medium">{event.number_of_guests}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Event Type:</span>
                  <span className="font-medium capitalize">{event.event_type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Budget:</span>
                  <span className="font-medium">${event.budget.toLocaleString()}</span>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center">
                  <CheckSquare className="w-5 h-5 mr-2" />
                  Checklist ({event.checklist.length} items)
                </CardTitle>
              </CardHeader>
              <CardContent>
                {event.checklist.length === 0 ? (
                  <p className="text-gray-600 italic">No checklist items added</p>
                ) : (
                  <div className="space-y-3">
                    {event.checklist.map((item, index) => (
                      <div key={index} className="flex items-center space-x-2">
                        <Checkbox id={`item-${index}`} />
                        <label
                          htmlFor={`item-${index}`}
                          className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                        >
                          {item}
                        </label>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  )
}
