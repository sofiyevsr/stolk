import React, { FC, useEffect, useRef, useState } from "react";

interface Props {
  from: number;
  to: number;
  duration: number;
  title: string;
  icon: JSX.Element;
  start: boolean;
}

const FPS = 20;
const Countdown: FC<Props> = ({ from, to, title, duration, icon, start }) => {
  const [count, setCount] = useState(from);
  const intervalRef = useRef<NodeJS.Timer>();
  const countRef = useRef(count);
  countRef.current = count;

  useEffect(() => {
    if (count >= to && intervalRef.current) {
      clearInterval(intervalRef.current);
    }
  }, [count]);

  useEffect(() => {
    if (start === true)
      intervalRef.current = setInterval(() => {
        const newCount = countRef.current + Math.floor((to - from) / (FPS * duration));
        if (newCount >= to) setCount(to);
        else setCount(newCount);
      }, 1000 / FPS);
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [start]);

  return (
    <div className="w-full py-3 my-3 text-center md:mx-10 rounded-md bg-primary-100">
      <div className="flex justify-center w-full">{icon}</div>
      <span className="block my-5 text-4xl font-black">{title}</span>
      <span className="text-4xl font-black text-gray-500 uppercase">
        {count === to ? `${count}+` : count}
      </span>
    </div>
  );
};

export default Countdown;
