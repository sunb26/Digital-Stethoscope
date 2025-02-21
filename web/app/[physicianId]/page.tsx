import { type Patient, columns } from "@/components/ui/patients/columns"
import { DataTable } from "@/components/ui/patients/data-table"

async function getData(): Promise<Patient[]> {
  // Fetch data from your API here.
  return [
    {
      id: 96,
      name: "Bob Saggit",
      email: "m@example.com",
      lastUpdated: "2021-09-01T00:00:00Z",
    },
    // ...
  ]
}

export default async function DemoPage() {
  const data = await getData()

  return (
    <div className="container mx-auto py-10">
      <DataTable columns={columns} data={data} />
    </div>
  )
}
