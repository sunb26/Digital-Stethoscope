// import Image from "next/image";
import { Hero } from "@/components/hero";
import { About } from "@/components/about";

export default function Home() {
  return (
    <main>
      <div className="flex flex-col justify-center justify-items-center gap-y-10">
        <section className="pt-40">
          <Hero />
        </section>
        <section>
          <About />
        </section>
      </div>
    </main>
  );
}
