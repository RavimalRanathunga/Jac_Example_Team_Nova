// import { getSession } from "@/lib/auth"
import { redirect } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import Link from "next/link"
import { Calendar, Users, CheckSquare, DollarSign } from "lucide-react"

export default async function HomePage() {
  // const user = await getSession()

  // if (user) {
  //   redirect("/dashboard")
  // }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-16">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">Event Manager</h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Plan, organize, and manage your events with ease. Keep track of guests, budgets, and checklists all in one
            place.
          </p>
          <div className="flex gap-4 justify-center">
            <Link href="/signup">
              <Button size="lg" className="px-8">
                Get Started
              </Button>
            </Link>
            <Link href="/login">
              <Button variant="outline" size="lg" className="px-8 bg-transparent">
                Sign In
              </Button>
            </Link>
          </div>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 max-w-6xl mx-auto">
          <Card>
            <CardHeader>
              <Calendar className="w-8 h-8 text-blue-600 mb-2" />
              <CardTitle>Event Planning</CardTitle>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Create and organize events with detailed information and planning tools.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <Users className="w-8 h-8 text-green-600 mb-2" />
              <CardTitle>Guest Management</CardTitle>
            </CardHeader>
            <CardContent>
              <CardDescription>Keep track of guest counts and manage attendee information efficiently.</CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <DollarSign className="w-8 h-8 text-yellow-600 mb-2" />
              <CardTitle>Budget Tracking</CardTitle>
            </CardHeader>
            <CardContent>
              <CardDescription>Monitor your event budgets and keep expenses under control.</CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CheckSquare className="w-8 h-8 text-purple-600 mb-2" />
              <CardTitle>Task Checklists</CardTitle>
            </CardHeader>
            <CardContent>
              <CardDescription>Create comprehensive checklists to ensure nothing is forgotten.</CardDescription>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
