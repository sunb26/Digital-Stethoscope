"use client"

import type { ColumnDef } from "@tanstack/react-table"

export type Patient = {
  id: number
  name: string
  email: string
  lastUpdated: string
}

export const columns: ColumnDef<Patient>[] = [
  {
    accessorKey: "name",
    header: "Full Name",
  },
  {
    accessorKey: "email",
    header: "Email",
  },
  {
    accessorKey: "lastUpdated",
    header: "Last Updated",
  },
]
