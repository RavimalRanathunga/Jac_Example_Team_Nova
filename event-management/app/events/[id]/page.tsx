"use client"

import { getEvent } from "@/lib/api"
import { notFound } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import Link from "next/link"
import { ArrowLeft, Edit, Users, CheckSquare } from "lucide-react"
import { DeleteEventButton } from "@/components/delete-event-button"
import { useState, useEffect,use } from "react"

export default function EventDetailsPage({ params }: { params: { id: string } }) {
  const [id, setId] = useState("")
  const [event_name,setName]=useState("")
  const [created_at,setCreatedAt]=useState("")
  const [event_type,setEventType]=useState("")
  const [updated_at,setUpdatedAt]=useState("")
  const [number_of_guests,setGuests]=useState("")
  const [budget,setBudget] =useState(0.00)
  const [checklist,setChecklist] = useState<string[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchData() {
      try {
        const eventId = { event_id: params.id }
        const data = await getEvent(eventId)
        if(data)
        {
        setId(data.id)
        setName(data.event_name)
        setCreatedAt(data.created_at)
        setEventType(data.event_type)
        setUpdatedAt(data.updated_at)
        setGuests(data.number_of_guests)
        setBudget(data.budget)
        setChecklist(data.checklist)
        }
      } catch (error) {
        notFound()
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [params.id])

  if (loading) return <div>Loading...</div>
  if (!event) return <div>Event not found</div>

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
              <Link href={`/events/${id}/edit`}>
                <Button variant="outline" size="sm">
                  <Edit className="w-4 h-4 mr-2" />
                  Edit
                </Button>
              </Link>
              <DeleteEventButton eventId={id} />
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
                  <CardTitle className="text-2xl">{event_name}</CardTitle>
                  <CardDescription>
                    Created on {new Date(created_at).toLocaleDateString()}
                    {updated_at !== created_at && (
                      <span> • Updated on {new Date(updated_at).toLocaleDateString()}</span>
                    )}
                  </CardDescription>
                </div>
                <Badge variant="secondary" className="text-sm">
                  {event_type}
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
                  <span className="font-medium">{number_of_guests}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Event Type:</span>
                  <span className="font-medium capitalize">{event_type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Budget:</span>
                  <span className="font-medium">${budget.toLocaleString()}</span>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center">
                  <CheckSquare className="w-5 h-5 mr-2" />
                  Checklist ({checklist.length} items)
                </CardTitle>
              </CardHeader>
              <CardContent>
                {checklist.length === 0 ? (
                  <p className="text-gray-600 italic">No checklist items added</p>
                ) : (
                  <div className="space-y-3">
                    {checklist.map((item, index) => (
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
