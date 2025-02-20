"use client";

import { useRouter, usePathname } from "next/navigation";

export function Header() {
  const router = useRouter();
  const pathName = usePathname();

  const handleNavigation = (sectionId: string) => {
    if (pathName === "/") {
      // Scroll to the section with the section ID
      document.location.href = `${sectionId}`;
    } else {
      // Navigate to the homepage with the section ID as a hash
      router.push(`/${sectionId}`);
    }
  };

  return (
    <header className="text-black p-4 text-center top-0 left-0 right-0">
      <nav className="container mx-auto flex justify-between items-center">
        <div className="font-bold cursor-pointer">
          {/* biome-ignore lint/a11y/useValidAnchor: */}
          <a onClick={() => handleNavigation("#home")}>
            <h1 className="text-2xl">HeartLink</h1>
          </a>
        </div>
        <ul className="flex gap-6 items-center">
          <li>
            <a
              className="hover:underline cursor-pointer text-dark-blue"
              // biome-ignore lint/a11y/useValidAnchor:
              onClick={() => handleNavigation("/")}
            >
              Home
            </a>
          </li>
          <li>
            <a
              className="hover:underline cursor-pointer text-dark-blue"
              // biome-ignore lint/a11y/useValidAnchor:
              onClick={() => handleNavigation("#about")}
            >
              About
            </a>
          </li>
          <li>
            <a
              className="hover:underline cursor-pointer text-dark-blue"
              // biome-ignore lint/a11y/useValidAnchor:
              onClick={() => handleNavigation("#oursolution")}
            >
              Our Solution
            </a>
          </li>
          <li>
            <button
              type="button"
              className="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
            >
              Login/Sign Up
            </button>
          </li>
        </ul>
      </nav>
    </header>
  );
}
