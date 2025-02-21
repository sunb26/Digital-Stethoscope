'use client'

import { SignedIn, SignedOut, SignInButton, useUser } from "@clerk/nextjs";
import { useRouter } from "next/navigation";

export const GettingStarted = () => {
  const router = useRouter()

  const { user } = useUser();
  const physicianId = user?.id;
  
  return (
    <div className="flex flex-col items-center gap-10 p-20">
      <h1 className="text-5xl font-[Playfair Display SC] font-bold">
        Experience the Future of Telemedicine Today!
      </h1>
      <p className="font-[Syne]">
        Let us help you provide better healthcare to patients everywhere!
      </p>
      <SignedOut>
        <SignInButton>
          <button
            type="button"
            className="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 shadow-lg shadow-red-500/50 dark:shadow-lg dark:shadow-red-800/80 font-medium rounded-lg text-sm px-10 py-4 text-center me-2 mb-2"
          >
            Get Started
          </button>
        </SignInButton>
      </SignedOut>
      <SignedIn>
        <button
          type="button"
          onClick={() => router.push(`/user/${physicianId}`)}
          className="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 shadow-lg shadow-red-500/50 dark:shadow-lg dark:shadow-red-800/80 font-medium rounded-lg text-sm px-10 py-4 text-center me-2 mb-2"
        >
          Get Started
        </button>
      </SignedIn>
    </div>
  );
};
