import { Rss, Link, Bell, PieChart, File, Users } from "react-feather";

const menus = [
  {
    id: 1,
    label: "Dashboard",
    url: "/",
    Icon: PieChart,
  },
  {
    id: 2,
    label: "Notification",
    url: "/notification",
    Icon: Bell,
  },
  {
    id: 3,
    label: "Reports",
    url: "/reports",
    Icon: File,
  },
  {
    id: 4,
    label: "Users",
    url: "/users",
    Icon: Users,
  },
  {
    id: 5,
    label: "Sources",
    url: "/sources",
    Icon: Link,
  },
  {
    id: 6,
    label: "News",
    url: "/news",
    Icon: Rss,
  },
];

export default menus;
