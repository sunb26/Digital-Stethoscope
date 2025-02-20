// import Image from "next/image";
import { Hero } from "@/components/hero";


export default function Home() {
  return (
    <main>
      <div className='flex flex-col justify-center justify-items-center gap-y-10'>
        <section className="pt-10">
          <Hero />
        </section>
      </div>
    </main>
  );
}
