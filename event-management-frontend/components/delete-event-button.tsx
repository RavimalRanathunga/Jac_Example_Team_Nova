"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { deleteEvent } from "@/lib/api"
import { Button } from "@/components/ui/button"
import { Trash2 } from "lucide-react"

interface DeleteEventButtonProps {
  eventId: string
}

export function DeleteEventButton({ eventId }: DeleteEventButtonProps) {
  const [isDeleting, setIsDeleting] = useState(false)
  const router = useRouter()

  const handleDelete = async () => {
    if (!confirm("Are you sure you want to delete this event? This action cannot be undone.")) {
      return
    }

    setIsDeleting(true)
    try {
      const deletepayload ={
        event_id:eventId
      }
      await deleteEvent(deletepayload)
      router.push("/dashboard")
    } catch (error) {
      console.error("Failed to delete event:", error)
      alert("Failed to delete event. Please try again.")
    } finally {
      setIsDeleting(false)
    }
  }

  return (
    <Button variant="destructive" size="sm" onClick={handleDelete} disabled={isDeleting}>
      <Trash2 className="w-4 h-4 mr-2" />
      {isDeleting ? "Deleting..." : "Delete"}
    </Button>
  )
}
