import { type Patient, columns } from "@/components/ui/patients/columns";
import { DataTable } from "@/components/ui/patients/data-table";
import { currentUser } from "@clerk/nextjs/server";

async function getData(): Promise<Patient[]> {
  // Fetch data from your API here.
  return [
    {
      id: 1,
      name: "John Smith",
      email: "john.smith@example.com",
      lastUpdated: "2024-02-15T09:30:00Z",
    },
    {
      id: 2,
      name: "Sarah Johnson",
      email: "sarah.j@example.com",
      lastUpdated: "2024-02-14T15:45:00Z",
    },
    {
      id: 3,
      name: "Miguel Rodriguez",
      email: "mrodriguez@example.com",
      lastUpdated: "2024-02-13T11:20:00Z",
    },
    {
      id: 4,
      name: "Emma Wilson",
      email: "emma.w@example.com",
      lastUpdated: "2024-02-12T16:15:00Z",
    },
    {
      id: 5,
      name: "Chen Wei",
      email: "chen.wei@example.com",
      lastUpdated: "2024-02-11T08:45:00Z",
    },
    {
      id: 6,
      name: "Priya Patel",
      email: "priya.p@example.com",
      lastUpdated: "2024-02-10T14:30:00Z",
    },
    {
      id: 7,
      name: "Alex Thompson",
      email: "alex.t@example.com",
      lastUpdated: "2024-02-09T10:20:00Z",
    },
    {
      id: 8,
      name: "Maria Garcia",
      email: "mgarcia@example.com",
      lastUpdated: "2024-02-08T13:15:00Z",
    },
    {
      id: 9,
      name: "James Wilson",
      email: "jwilson@example.com",
      lastUpdated: "2024-02-07T17:40:00Z",
    },
    {
      id: 10,
      name: "Lisa Anderson",
      email: "lisa.a@example.com",
      lastUpdated: "2024-02-06T12:10:00Z",
    },
    {
      id: 11,
      name: "David Kim",
      email: "dkim@example.com",
      lastUpdated: "2024-02-05T09:55:00Z",
    },
    // ...
  ];
}

export default async function DemoPage() {
  const physician = await currentUser();
  const data = await getData();

  return (
    <div>
      <div className="bg-off-white">
        <h1 className="text-4xl font-bold text-center py-10 font-[Syne]">
          Welcome {physician?.fullName}
        </h1>
      </div>
      <div className="container mx-auto py-10">
        <h2 className="text-2xl font-bold pb-4 font-[Syne]">Your Patients</h2>
        <DataTable columns={columns} data={data} />
      </div>
    </div>
  );
}
