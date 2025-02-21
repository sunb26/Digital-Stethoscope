import Image from 'next/image';

export function Hero() {
  return (
    <section>
      <div className='flex flex-row justify-center justify-items-center'>
        <Image
          src="/logo.svg"
          width={800}
          height={800}
          alt="Picture of HeartLink Logo"
          />
      </div>
    </section>
  );
}

