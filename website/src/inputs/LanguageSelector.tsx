import { Menu, Transition } from "@headlessui/react";
import { useRouter } from "next/router";
import Image from "next/image";
import React from "react";
import { ChevronDownIcon } from "@heroicons/react/solid";

const languages = [
  { code: "az", value: "Azərbaycanca" },
  { code: "en", value: "English" },
  { code: "ru", value: "Русский" },
];
function LanguageSelector() {
  const router = useRouter();
  function changeLanguage(lang: string) {
    router.push(router.route, undefined, { locale: lang });
  }
  return (
    <Menu as="div" className="relative inline-block text-left">
      <div>
        <Menu.Button className="inline-flex justify-center w-full px-4 py-2 text-sm font-medium ring-1 rounded-md bg-opacity-20 hover:bg-opacity-30 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
          {router.locale}
          <ChevronDownIcon
            className="w-5 h-5 ml-2 -mr-1 text-violet-200 hover:text-violet-100"
            aria-hidden="true"
          />
        </Menu.Button>
      </div>
      <Transition
        enter="transition ease-out duration-100"
        enterFrom="transform opacity-0 scale-0"
        enterTo="transform opacity-100 scale-100"
        leave="transition ease-in duration-75"
        leaveFrom="transform opacity-100 scale-100"
        leaveTo="transform opacity-0 scale-0"
      >
        <Menu.Items className="absolute right-0 mt-1 origin-top-right bg-white divide-y divide-gray-300 rounded-md shadow-lg focus:outline-none">
          {languages.map(({ value, code }) => (
            <Menu.Item key={code}>
              {({ active }) => (
                <button
                  className={`${
                    active ? "bg-violet-500 scale" : "text-gray-900"
                  } group flex rounded-md items-center w-full px-2 py-3 text-sm`}
                  onClick={() => changeLanguage(code)}
                >
                  <Image
                    alt={`flag-${code}`}
                    className={"rounded-md"}
                    src={`/assets/vectors/${code}.svg`}
                    layout={"fixed"}
                    width={22}
                    height={22}
                  />
                  <span className="px-2">{value}</span>
                </button>
              )}
            </Menu.Item>
          ))}
        </Menu.Items>
      </Transition>
    </Menu>
  );
}

export default LanguageSelector;
