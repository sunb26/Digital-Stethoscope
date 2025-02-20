// import Image from "next/image";
import { Hero } from "@/components/hero";
import { About } from "@/components/about";
import { GettingStarted } from "@/components/getting_started";

export default function Home() {
  return (
    <main>
      <div className="flex flex-col justify-center justify-items-center gap-y-10">
        <section id="/" className="pt-40">
          <Hero />
        </section>
        <section id="about">
          <About />
        </section>
        <section>
          <GettingStarted />
        </section>
      </div>
    </main>
  );
}
