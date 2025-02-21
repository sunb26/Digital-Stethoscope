import { type Recording, columns } from "@/components/ui/recordings/columns";
import { DataTable } from "@/components/ui/recordings/data-table";
import Image from "next/image";

const Patient = {
  firstName: "John",
  lastName: "Doe",
  email: "example@gmail.com",
  age: 25,
  sex: "M",
  weight: "160 lbs",
  height: "180 cm",
};

async function getRecordings(): Promise<Recording[]> {
  // Fetch data from your API here.
  return [
    {
      id: 1,
      date: "2024-02-21T14:30:00Z",
      url: "https://storage.example.com/recordings/feb2024/call-a7x9d8.mp4",
    },
    {
      id: 2,
      date: "2024-02-20T09:15:00Z",
      url: "https://storage.example.com/recordings/feb2024/meeting-b8k2m5.mp4",
    },
    {
      id: 3,
      date: "2024-02-19T16:45:00Z",
      url: "https://storage.example.com/recordings/feb2024/interview-c9j3n6.mp4",
    },
    {
      id: 4,
      date: "2024-02-18T11:20:00Z",
      url: "https://storage.example.com/recordings/feb2024/presentation-d4h7p2.mp4",
    },
    {
      id: 5,
      date: "2024-02-17T13:00:00Z",
      url: "https://storage.example.com/recordings/feb2024/workshop-e5v8q1.mp4",
    },
    {
      id: 6,
      date: "2024-02-16T15:30:00Z",
      url: "https://storage.example.com/recordings/feb2024/training-f2w9r4.mp4",
    },
    {
      id: 7,
      date: "2024-02-15T10:45:00Z",
      url: "https://storage.example.com/recordings/feb2024/demo-g6t5s8.mp4",
    },
    {
      id: 8,
      date: "2024-02-14T12:15:00Z",
      url: "https://storage.example.com/recordings/feb2024/standup-h1y7m3.mp4",
    },
    {
      id: 9,
      date: "2024-02-13T09:00:00Z",
      url: "https://storage.example.com/recordings/feb2024/review-i8u4k7.mp4",
    },
    {
      id: 10,
      date: "2024-02-12T14:20:00Z",
      url: "https://storage.example.com/recordings/feb2024/planning-j3l6n9.mp4",
    },
    {
      id: 11,
      date: "2024-02-11T16:30:00Z",
      url: "https://storage.example.com/recordings/feb2024/session-k7m2p5.mp4",
    },
    {
      id: 12,
      date: "2024-02-10T11:45:00Z",
      url: "https://storage.example.com/recordings/feb2024/webinar-l4n8q6.mp4",
    },
    {
      id: 13,
      date: "2024-02-09T10:00:00Z",
      url: "https://storage.example.com/recordings/feb2024/meeting-m9r3s7.mp4",
    },
    // ...
  ];
}

export default async function PatientPage() {
  const recordings = await getRecordings();

  return (
    <div>
      <div className="bg-off-white">
        <div className="container mx-auto flex items-center gap-16">
          <div className="w-48 h-48 rounded-full overflow-hidden">
            <Image
              src={"/fallback-avatar.svg"}
              width={200}
              height={200}
              alt="Patient Avatar"
              className="w-full h-full object-cover"
            />
          </div>
          <p className="text-3xl text-left py-10 font-[Syne] whitespace-pre-line">
            First Name: {Patient.firstName}
            <br />
            Last Name: {Patient.lastName}
            <br />
            Email: {Patient.email}
            <br />
            Age: {Patient.age}
            <br />
            Sex: {Patient.sex}
            <br />
            Weight: {Patient.weight}
            <br />
            Height: {Patient.height}
          </p>
        </div>
      </div>
      <div className="container mx-auto py-10">
        <h2 className="text-2xl font-bold pb-4 font-[Syne]">Recordings</h2>
        <DataTable columns={columns} data={recordings} />
      </div>
    </div>
  );
}
