"use client"

import { Button } from "@/components/ui/button"
import { LogOut } from "lucide-react"
import { logoutUser } from "@/lib/api"
import { useRouter } from "next/navigation"

export function LogoutButton() {
  const router = useRouter()

  const handleLogout = async () => {
    try {
      await logoutUser()
      router.push("/")
    } catch (error) {
      console.error("Logout failed:", error)
      // Still redirect even if logout fails
      router.push("/")
    }
  }

  return (
    <Button variant="outline" onClick={handleLogout}>
      <LogOut className="w-4 h-4 mr-2" />
      Logout
    </Button>
  )
}
