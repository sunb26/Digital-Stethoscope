import Image from 'next/image';

export function Hero() {
  return (
    <section>
      <div className='flex flex-row justify-center justify-items-center'>
        <Image
          src="/logo.png"
          width={720}
          height={720}
          alt="Picture of HeartLink Logo"
          />
      </div>
    </section>
  );
}

